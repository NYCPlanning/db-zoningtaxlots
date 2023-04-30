# import dotenv
import requests
from constants import sql_engine
from sqlalchemy import text
import boto3
import os
import json


s3_client = boto3.client(
    "s3",
    aws_access_key_id=os.getenv("AWS_ACCESS_KEY_ID"),
    aws_secret_access_key=os.getenv("AWS_SECRET_ACCESS_KEY"),
    endpoint_url=os.getenv("AWS_S3_ENDPOINT")
)
aws_s3_bucket = "edm-recipes"
library_sql_folder = ".library"


def get_version(dataset:str, version:str="latest"):
    obj = s3_client.get_object(aws_s3_bucket, f"datasets/{dataset}/{version}/config.json")
    return json.load(obj["Body"])["dataset"]["version"]


def get_sql_file(dataset:str, version:str="latest", overwrite=False):
    filepath = f"{library_sql_folder}/{dataset}.sql"
    if os.path.exists(filepath) and not overwrite:
        print(f"✅ {dataset}.sql exists in cache")
    else:
        print(f"🛠 Downloading {dataset}.sql...")
        s3_client.download_file(aws_s3_bucket, f"datasets/{dataset}/{version}/{dataset}.sql", )
    return True
    
    
def run_sql_file(folder, filename):
    with sql_engine.connect() as conn, open(f"{folder}/{filename}.sql") as file:
        conn.execute(statement=text(file.read()))