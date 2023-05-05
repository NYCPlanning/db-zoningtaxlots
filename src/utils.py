import os
import json
import re
from pathlib import Path
import glob
import pandas as pd
from dotenv import load_dotenv
import subprocess
import boto3
import zipfile
from prefect import task
from osgeo import gdal

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


def record_version(dataset, version):
    with build_engine.begin() as conn:
        conn.execute(f"""
        DELETE FROM versions WHERE datasource = '{dataset}';
        INSERT INTO versions VALUES ('{dataset}', '{version}');
        """)


# adapted from https://stackoverflow.com/questions/56426471/upload-folder-with-sub-folders-and-files-on-s3-using-python
def upload_folder(local_folder, target_folder):
    cwd = str(Path.cwd())
    p = Path(os.path.join(Path.cwd(), local_folder))
    folders = list(p.glob("**"))
    for folder in folders:
        file_names = glob.glob(folder)
        file_names = [f for f in file_names if not Path(f).is_dir()]
        for _, file_name in enumerate(file_names):
            file_name = str(file_name).replace(cwd, "")
            print(f"fileName {file_name}")

            s3_path = os.path.join(f"db-zoningtaxlots{target_folder}", str(file_name))
            s3_client.upload_file(file_name, aws_s3_bucket, s3_path)


def read_sql_file_as_text(path:str):
    with open(path, 'r') as file:
        query = file.read()
        return re.sub(":[\"']([^\"']*)[\"']", "%(\g<1>)", query)


def run_sql_file(folder: str, filename: str, engine: str = "BUILD_ENGINE", **kwargs):
    # Has issues becuase dump is really meant for psql
    # with build_engine.connect() as conn, open(f"{folder}/{filename}.sql") as file:
    #    conn.execute(statement=text(file.read()))
    args = " ".join([f"-v {key}={kwargs[key]}" for key in kwargs])
    subprocess.run(
        [
            f"psql {os.environ[engine]} --set ON_ERROR_STOP=1 --file {folder}/{filename}.sql {args}"
        ],
        shell=True,
        check=True,
    )


def run_sql_query(query: str, edm_data=False):
    if edm_data:
        engine = edm_data_engine
    else:
        engine = build_engine

    with engine.begin() as conn:
        conn.execute(query)


@task
def load_to_edm():
    subprocess.run(
        [
            f'psql $EDM_DATA -c "DROP TABLE IF EXISTS dcp_zoningtaxlots.dcp_zoning_taxlot;"'
        ],
        shell=True,
        check=True,
    )
    subprocess.run(
        [
            f"pg_dump -t dcp_zoning_taxlot {os.environ['BUILD_ENGINE']} | sed -e 's/public\./dcp_zoningtaxlots./g' -e ' | psql {os.environ['EDM_DATA']}"
        ],
        shell=True,
        check=True,
    )
    statement = f"""
        DROP TABLE IF EXISTS dcp_zoningtaxlots.\"{os.environ['VERSION']}\";
        ALTER TABLE dcp_zoningtaxlots.dcp_zoning_taxlot RENAME TO \"{os.environ['VERSION']}\";
    """
    subprocess.run(
        [f'psql $EDM_DATA -c "{statement}"'],
        shell=True,
        check=True,
    )


@task(name="CSV Export", task_run_name="Export {source} to csv")
def csv_export(source: str, output: str = None, edm_data=False, order_by_timestamp=False, **kwargs):
    if edm_data:
        engine = edm_data_engine
    else:
        engine = build_engine

    if output is None:
        output = source.split(".")[-1]

    # assume source to be file or table
    if ".sql" not in source:
        if order_by_timestamp:
            query = f"SELECT * FROM {source} ORDER BY version"#::timestamp;"
        else:
            query = f"SELECT * FROM {source};"
    else:
        query = read_sql_file_as_text(source)
        

    with engine.begin() as conn:
        df = pd.read_sql_query(query, conn, params=kwargs)
        df.to_csv(f"output/{output}.csv")


@task(
    name="SHP export using subprocess",
    task_run_name="Export {table} to zipped shapefile",
)
def shp_export_subprocess(table: str):
    user, pw, host, port, db = re.match(
        "^.+://(.+):(.*)@(.*):(.*)/(.*)", os.environ["BUILD_ENGINE"]
    ).groups()
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


@task(name="SHP Export", task_run_name="Export {table} to zipped shapefile")
def shp_export(table: str):
    user, pw, host, port, db = re.match(
        "^.+://(.+):(.*)@(.*):(.*)/(.*)", os.environ["BUILD_ENGINE"]
    ).groups()
    conn_string = f"PG:host={host} dbname={db} user={user} password={pw} port={port}"
    data_source = gdal.OpenEx(conn_string, gdal.OF_VECTOR)
    filepath = f"output/{table}"

    gdal.VectorTranslate(
        filepath,
        data_source,
        format="ESRI Shapefile",
        geometryType="MULTIPOLYGON",
        sql=f"SELECT * FROM {table}",
        layerName=table,
    )

    with zipfile.ZipFile(
        f"output/{table}.zip", "w", compression=zipfile.ZIP_DEFLATED, compresslevel=9
    ) as _zip:
        for f in os.listdir(filepath):
            _zip.write(f, os.path.basename(f))
            os.remove(f)
