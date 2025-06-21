# chainlit_mysql_localstack_demo
a demo for chainlit using mysql localstack as datalayer

## get started

### prerequisites

install python
install uv
docker
docker compose

### install dep
``` cmd
uv sync
```
### start the mysql and localstack service
``` cmd
docker compose up -d
```
### make ready the database structure
``` import sql
import the data structure in the file chainlit.sql
```
### alles bereit!! app los !

``` cmd
uv run chainlit run app.py
```