import json
import os
import psycopg2
import logging

from azure.identity import DefaultAzureCredential
from azure.storage.blob import BlobServiceClient
from azure.core.exceptions import HttpResponseError

from fastapi import FastAPI, HTTPException

logger = logging.getLogger(__name__)
logger.setLevel(logging.DEBUG)

app = FastAPI()

logger.info("API is starting up")

@app.get("/")
def read_root():
    logger.debug("Hit /")
    return {"Hello": "World"}


def init_db(conn):
    # Open and read the local file "init.sql"
    file_path = '/app/examples/init.sql'

    with open(file_path, 'r') as file:
        conn.cursor().execute(file.read())

@app.get("/examples")
def read_examples():
    logger.debug("Hit /examples")
    try:
        conn = psycopg2.connect(
            host=get_environment_variable("DATABASE_HOST"),
            port=get_environment_variable("DATABASE_PORT", "5432"),
            database=get_environment_variable("DATABASE_NAME", "postgres"),
            user=get_environment_variable("DATABASE_USER"),
            password=get_environment_variable("DATABASE_PASSWORD"),
            connect_timeout=1,
        )

        init_db(conn)
        cur = conn.cursor()
        cur.execute("SELECT * FROM example")
        examples = cur.fetchall()
        return {"examples": examples}
    except psycopg2.OperationalError as error:
        logger.error(error)
        raise HTTPException(status_code=500, detail=str(error))


def get_environment_variable(key, default=None):
    value = os.environ.get(key, default)

    if value is None:
        raise RuntimeError(f"{key} does not exist")

    return value


@app.get("/quotes")
def read_quotes():
    logger.debug("Hit /quotes")
    try:
        account_url = get_environment_variable("STORAGE_ACCOUNT_URL")
        default_credential = DefaultAzureCredential(process_timeout=2)
        blob_service_client = BlobServiceClient(account_url, credential=default_credential)

        container_client = blob_service_client.get_container_client(container="api")
        quotes = json.loads(container_client.download_blob("quotes.json").readall())
    except HttpResponseError as error:
        raise HTTPException(status_code=500, detail=str(error))

    return {"quotes": quotes}
