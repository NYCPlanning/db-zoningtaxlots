from prefect import task, flow
from utils import run_sql_file



@task
def run_sql_build_file(file):
    run_sql_file("sql", file)
    return True


@flow
def build_1():
    run_sql_build_file.submit("create_priority")
    run_sql_build_file("create")
    run_sql_build_file("preprocessing")
    run_sql_build_file("bbl")
    

@flow
def build_2(ready=True):
    run_sql_build_file.submit("area_zoningdistrict_create")
    run_sql_build_file.submit("area_commercialoverlay")
    run_sql_build_file.submit("area_specialdistrict")
    run_sql_build_file.submit("area_limitedheight")
    run_sql_build_file.submit("area_zoningmap")
    return True
    
    
@flow
def build_3(ready=True):
    run_sql_build_file("area_zoningdistrict")
    run_sql_build_file("parks")
    run_sql_build_file("inzonechange")
    run_sql_build_file("correct_duplicatevalues")
    run_sql_build_file("correct_zoninggaps")
    run_sql_build_file("correct_invalidrecords")
    return True

@flow
def build():
    res_1 = build_1()
    res_2 = build_2(wait_for=res_1)
    res_3 = build_3(wait_for=res_2)
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