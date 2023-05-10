from prefect import task, flow
from utils import run_sql_file, load_to_edm


@task(name="Execute sql file", task_run_name="Execute {file}.sql")
def run_sql_build_file(file: str):
    run_sql_file("sql", file)


@flow
def build_1():
    run_sql_build_file.submit("create_priority")
    run_sql_build_file("create")
    run_sql_build_file("preprocessing")
    run_sql_build_file("bbl")


@flow
def build_2():
    run_sql_build_file.submit("area_zoningdistrict_create")
    run_sql_build_file.submit("area_commercialoverlay")
    run_sql_build_file.submit("area_specialdistrict")
    run_sql_build_file.submit("area_limitedheight")
    run_sql_build_file.submit("area_zoningmap")
    return True


@flow
def build_3():
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
    load_to_edm(wait_for=res_3)
    return True


@flow
def edm():
    load_to_edm()


if __name__ == "__main__":
    build()
