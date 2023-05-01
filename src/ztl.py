from prefect import flow
from prefect.task_runners import SequentialTaskRunner
from dataloading import dataloading
from build import build

@flow(task_runner=SequentialTaskRunner())
def db_zoningtaxlots():
    print("Running ztl")
    dataloading()
    build()
    #qaqc
    return True

if __name__ == "__main__":
    db_zoningtaxlots()