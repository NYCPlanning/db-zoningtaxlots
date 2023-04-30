from prefect import flow
from prefect.task_runners import SequentialTaskRunner
from dataloading import dataloading
from build import build
from dotenv import load_dotenv

load_dotenv()

@flow(task_runner=SequentialTaskRunner())
def db_zoningtaxlots():
    print("Running ztl")
    dataloading()
    build()
    #qaqc
    return True

db_zoningtaxlots()