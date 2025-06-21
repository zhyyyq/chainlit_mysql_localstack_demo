from sqlalchemy.ext.asyncio import create_async_engine
import asyncio



async def main():
  # Replace with your MySQL credentials and database name
  DATABASE_URL = "mysql+aiomysql://chainlit:chainlit@127.0.0.1:3306/chainlit"
  engine = create_async_engine(DATABASE_URL, echo=True) # echo=True for logging SQL queries
  async with engine.connect() as conn:
        result = await conn.exec_driver_sql("show tables")
        print(result)

if __name__ == '__main__':
  
  asyncio.run(main())
