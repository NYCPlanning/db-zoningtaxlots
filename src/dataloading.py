from prefect import task, flow

from constants import input_datasets, sql_engine
from utils import get_version, get_sql_file, run_sql_file, library_sql_folder


@task(name="Import dataset", task_run_name="Import {dataset}")
def import_dataset(dataset: str, version: str = "latest"):
    version = get_version(dataset, version=version)
    # Download sql dump for the datasets from data library
    get_sql_file(dataset, version)
    print(f"Download complete. Running {dataset}.sql")
    run_sql_file(library_sql_folder, dataset)
    return True


@task(name="Create versions table")
def create_versions_table():
    with sql_engine.begin() as conn:
        conn.execute(
            """
            DROP TABLE IF EXISTS versions;
            CREATE TABLE versions ( 
                datasource text, 
                version text 
            );"""
        )
    return True


@flow
def dataloading():
    ready = create_versions_table()
    import_dataset.map(input_datasets, wait_for=ready)
