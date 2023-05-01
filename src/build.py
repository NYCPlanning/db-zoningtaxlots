from prefect import task, flow
from utils import run_sql_file



@task
def run_sql_build_file(file):
    run_sql_file("sql", file)
    return True


@flow
def build_1():
    run_sql_build_file("create_priority")
    run_sql_build_file("create")
    run_sql_build_file("prepprocessing")
    run_sql_build_file("bbl")
    

@flow
def build_2(ready=True):
    run_sql_build_file("area_zoningdistrict_create")
    run_sql_build_file("area_commercialoverlay")
    run_sql_build_file("area_specialdistrict")
    run_sql_build_file("area_limitedheight")
    run_sql_build_file("area_zoningmap")
    return True
    
    
@flow
def build_3(ready=True):
    run_sql_build_file("area_zoningdistrict")
    run_sql_build_file("parks")
    run_sql_build_file("inzonechange")
    run_sql_build_file("correct_duplicatevalues")
    run_sql_build_file("correct_zoninggap")
    run_sql_build_file("correct_invalidrecords")
    return True

@flow
def build():
    ready = build_1()
    ready = build_2(ready)
    ready = build_3(ready)
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