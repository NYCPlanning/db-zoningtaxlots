from prefect import task, flow

from constants import input_datasets, build_engine
from utils import get_version, get_sql_file, run_sql_file, library_sql_folder, record_version


@task(name="Import dataset", task_run_name="Import {dataset}")
def import_dataset(dataset: str, version: str = "latest"):
    version = get_version(dataset, version=version)
    get_sql_file(dataset, version)
    print(f"Download complete. Running {dataset}.sql")
    run_sql_file(library_sql_folder, dataset)
    record_version(dataset, version)


@task(name="Create versions table")
def create_versions_table():
    with build_engine.begin() as conn:
        conn.execute(
            """
            DROP TABLE IF EXISTS source_data_versions;
            CREATE TABLE source_data_versions ( 
                schemaname text, 
                v text 
            );"""
        )


@flow
def dataloading():
    ready = create_versions_table()
    import_dataset.map(input_datasets, wait_for=ready)


if __name__ == "__main__":
    dataloading()
