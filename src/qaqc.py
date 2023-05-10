import os
import datetime
from prefect import task, flow
from utils import run_sql_file, csv_export, shp_export, upload_folder


@task(name="Create Export Table", task_run_name="Create Export Table")
def create_export_table():
    run_sql_file("sql", "export")
    return True


@task(name="Execute QAQC sql file", task_run_name="Execute {file}.sql")
def edm_qaqc_sql_step(file: str):
    run_sql_file(
        "sql/qaqc",
        file,
        engine="EDM_DATA",
        VERSION=os.environ["VERSION"],
        VERSION_PREV=os.environ["VERSION_PREV"],
    )
    return True


@flow(name="Run QAQC logic")
def qaqc():
    create_export_table.submit()
    edm_qaqc_sql_step("frequency")
    edm_qaqc_sql_step("bbl")
    edm_qaqc_sql_step("mismatch")
    edm_qaqc_sql_step("out_bbldiffs")
    run_sql_file(
        "sql/qaqc", "in_bbldiffs"
    )  # runs locally, not on edm_data TODO not currently a task
    return True


@flow(name="Generate outputs")
def generate_outputs():
    os.makedirs("output", exist_ok=True)
    csv_export.submit("source_data_versions")
    csv_export.submit("dcp_zoning_taxlot_export", output="zoningtaxlot_db")

    csv_export.submit("dcp_zoningtaxlots.qaqc_frequency", edm_data=True, order_by_timestamp=True)
    csv_export.submit("dcp_zoningtaxlots.qaqc_bbl", edm_data=True, order_by_timestamp=True)
    csv_export.submit("dcp_zoningtaxlots.qaqc_mismatch", edm_data=True, order_by_timestamp=True)

    csv_export.submit("qc_bbldiffs")
    shp_export.submit("qc_bbldiffs")

    with open("output/version.txt", "w") as file:
        file.write(datetime.date.today().strftime("%Y/%m/01"))

    csv_export.submit(
        "sql/qaqc/versioncomparison.sql",
        output="qc_versioncomparison",
        edm_data=True,
        VERSION=os.environ["VERSION"],
        VERSION_PREV=os.environ["VERSION_PREV"],
    )
    csv_export.submit(
        "sql/qaqc/null.sql",
        output="qaqc_null",
        edm_data=True,
        VERSION=os.environ["VERSION"],
        VERSION_PREV=os.environ["VERSION_PREV"],
    )


@task(name="Upload")
def upload():
    upload_folder("output", datetime.date.today().strftime("%Y%m%d"))


if __name__ == "__main__":
    qaqc()
    generate_outputs()
