import os
import requests
import sqlalchemy
from prefect import task, flow
from prefect.task_runners import SequentialTaskRunner

from constants import input_datasets, sql_engine
from utils import get_acl, get_version, get_sql_file, run_sql_file, library_sql_folder

@task
def import_dataset(dataset:str, version:str="latest", ready=True):
    version=get_version(dataset, version=version)
    # Download sql dump for the datasets from data library
    filepath = f".library/{dataset}.sql"
    get_sql_file(dataset, version)
    print(f"Download complete. Running {dataset}.sql")
    run_sql_file(library_sql_folder, dataset)
    return True

@task
def create_versions_table():
    with sql_engine.begin() as conn:
        conn.execute("""
            DROP TABLE IF EXISTS versions;
            CREATE TABLE versions ( 
                datasource text, 
                version text 
            );""")
    return True

flow()
def dataloading():
    ready = create_versions_table()
    for dataset in input_datasets:
        import_dataset(dataset, ready=ready)