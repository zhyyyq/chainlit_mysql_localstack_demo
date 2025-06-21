import chainlit as cl
from local_s3 import S3StorageClient
from chainlit.data import get_data_layer
from chainlit.input_widget import TextInput
from mysql_sqlalchemy_data_layer import MysqlSQLAlchemyDataLayer

storage_client = S3StorageClient(
    bucket="my-bucket",
    region_name="eu-central-1",
    endpoint_url="http://localhost:4566",
    aws_access_key_id="test",
    aws_secret_access_key="test",
    use_ssl=False,
    verify=False,
)


@cl.data_layer
def mysql_data_layer():
    return MysqlSQLAlchemyDataLayer(
        conninfo="mysql+aiomysql://chainlit:chainlit@127.0.0.1:3306/chainlit",
        storage_provider=storage_client,
        show_logger=True,
    )


@cl.password_auth_callback
async def auth_callback(username: str, password: str):
    # Add your own logic to check if the user exists and the password is correct.
    # If the user doesn't exist, create them (registration).
    data_layer = get_data_layer()
    user = await data_layer.get_user(username)
    if not user:
        # Registration logic
        user = cl.User(identifier=username, metadata={"password": password})
        user = await data_layer.create_user(user)
        return user
    else:
        # check password
        if user.metadata["password"] == password:
            return user
        else:
            return None
    # Return the user if authentication/registration is successful
    return user


@cl.on_chat_resume
async def on_chat_resume(thread):
    pass


@cl.step(type="tool")
async def tool():
    # Fake tool
    await cl.sleep(2)
    return "Response from the tool!"


@cl.on_message  # this function will be called every time a user inputs a message in the UI
async def main(message: cl.Message):
    """
    This function is called every time a user inputs a message in the UI.
    It sends back an intermediate response from the tool, followed by the final answer.

    Args:
        message: The user's message.

    Returns:
        None.
    """

    # Call the tool
    tool_res = await tool()

    await cl.Message(content=tool_res).send()


@cl.on_chat_start
async def start():
    user: cl.User = cl.user_session.get("user")
    settings: dict = user.metadata.get("settings", {})
    settings = await cl.ChatSettings(
        [
            TextInput(
                id="username", label="username", initial=settings.get("username", "")
            )
        ]
    ).send()


@cl.on_settings_update
async def setup_agent(settings):
    print("on_settings_update", settings)
    data_layer = get_data_layer()
    user: cl.User = cl.user_session.get("user")
    user.metadata["settings"] = settings
    # update user metadata
    await data_layer.create_user(user)
