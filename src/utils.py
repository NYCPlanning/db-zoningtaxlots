import os
import json
import re
from pathlib import Path
import glob
import pandas as pd
from dotenv import load_dotenv
import subprocess
import boto3
from prefect import task

from constants import build_engine, edm_data_engine

load_dotenv()

s3_client = boto3.client(
    "s3",
    aws_access_key_id=os.getenv("AWS_ACCESS_KEY_ID"),
    aws_secret_access_key=os.getenv("AWS_SECRET_ACCESS_KEY"),
    endpoint_url=os.getenv("AWS_S3_ENDPOINT"),
)
aws_s3_bucket = "edm-recipes"
library_sql_folder = ".library"


def get_version(dataset: str, version: str = "latest"):
    key = f"datasets/{dataset}/{version}/config.json"
    print(key)
    obj = s3_client.get_object(
        Bucket=aws_s3_bucket, Key=f"datasets/{dataset}/{version}/config.json"
    )
    return json.load(obj["Body"])["dataset"]["version"]


def get_sql_file(dataset: str, version: str = "latest", overwrite=False):
    filepath = f"{library_sql_folder}/{dataset}.sql"
    if os.path.exists(filepath) and not overwrite:
        print(f"✅ {dataset}.sql exists in cache")
    else:
        print(f"🛠 Downloading {dataset}.sql...")
        s3_client.download_file(
            aws_s3_bucket, f"datasets/{dataset}/{version}/{dataset}.sql", filepath
        )
        
# adapted from https://stackoverflow.com/questions/56426471/upload-folder-with-sub-folders-and-files-on-s3-using-python
def export_folder(local_folder, target_folder):
    cwd = str(Path.cwd())
    p = Path(os.path.join(Path.cwd(), local_folder))
    folders = list(p.glob('**'))
    for folder in folders:
        file_names = glob.glob(folder)
        file_names = [f for f in file_names if not Path(f).is_dir()]
        for _, file_name in enumerate(file_names):
            file_name = str(file_name).replace(cwd, '')
            print(f"fileName {file_name}")

            s3_path = os.path.join(f"db-zoningtaxlots{target_folder}", str(file_name))
            s3_client.upload_file(file_name, aws_s3_bucket, s3_path)


def run_sql_file(folder:str, filename:str, engine:str='BUILD_ENGINE', **kwargs):
    # Has issues becuase dump is really meant for psql
    # with sql_engine.connect() as conn, open(f"{folder}/{filename}.sql") as file:
    #    conn.execute(statement=text(file.read()))
    args = " ".join([f"-v {key}={kwargs[key]}" for key in kwargs])
    subprocess.run(
        [
            f"psql {os.environ[engine]} --set ON_ERROR_STOP=1 --file {folder}/{filename}.sql {args}"
        ],
        shell=True,
        check=True,
    )


@task(name="CSV Export", task_run_name="Export {source} to csv")
def csv_export(source:dict, output:str=None, edm_data=False, **kwargs):
    if edm_data:
        engine = edm_data_engine
    else:
        engine = build_engine
        
    if output is None: output = source.split(".")[-1]
        
    # assume source to be file or table
    if ".sql" not in source:
        source = f"SELECT * FROM {source['table']} ORDER BY version::timestamp"
        
    with engine.begin() as conn:
        df = pd.read_sql(source, conn, params=kwargs)
        df.to_csv(f"output/{output}.csv")


@task(name="SHP Export", task_run_name="Export {table} to zipped shapefile")
def shp_export(table):
    user, pw, host, port, db = re.match("^.+://(.+):(.*)@(.*):(.*)/(.*)", os.environ["BUILD_ENGINE"]).groups()
    filepath = f"output/{table}/{table}"
    cmd = f"""
        ogr2ogr -progress -f "ESRI Shapefile" {filepath}.shp \
            PG:"host={host} user={user} port={port} dbname={db} password={pw}" \
            {table} -nlt MULTIPOLYGON
        rm -f {filepath}.zip
        zip {filepath}.zip *
        ls | grep -v output/{table}.zip | xargs rm
    """
    subprocess.run(cmd, shell=True, check=True)
    