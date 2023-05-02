from prefect import task, flow
from utils import run_sql_file



@task
def run_sql_build_file(file):
    run_sql_file("sql", file)
    return True

@flow
def build():
    res_1 = run_sql_build_file.map([
        "create_priority",
        "create",
        "preprocessing",
        "bbl"
    ])
    res_2 = run_sql_build_file.map([
        "area_zoningdistrict_create",
        "area_commercialoverlay",
        "area_specialdistrict",
        "area_limitedheight",
        "area_zoningmap"
    ], wait_for=res_1)
    res_3 = run_sql_build_file.map([
        "area_zoningdistrict",
        "parks",
        "inzonechange",
        "correct_duplicatevalues",
        "correct_zoninggaps",
        "correct_invalidrecords"
    ], wait_for=res_2)
    return True
    
    """todo
echo "archive final output"
pg_dump -t dcp_zoning_taxlot $BUILD_ENGINE | psql $EDM_DATA
psql $EDM_DATA -c "
  CREATE SCHEMA IF NOT EXISTS dcp_zoningtaxlots;
  ALTER TABLE dcp_zoning_taxlot SET SCHEMA dcp_zoningtaxlots;
  DROP TABLE IF EXISTS dcp_zoningtaxlots.\"$VERSION\";
  ALTER TABLE dcp_zoningtaxlots.dcp_zoning_taxlot RENAME TO \"$VERSION\";
"
    """
    return 0