from prefect import flow
from prefect.task_runners import SequentialTaskRunner
from dataloading import dataloading
from build import build
from qaqc import qaqc, generate_outputs


@flow(task_runner=SequentialTaskRunner())
def db_zoningtaxlots():
    print("Running ztl")
    data_loaded = dataloading()
    built = build(wait_for=data_loaded)
    qaqcd = qaqc(wait_for=built)
    outputs = generate_outputs(wait_for=qaqcd)
    return True


if __name__ == "__main__":
    db_zoningtaxlots()
