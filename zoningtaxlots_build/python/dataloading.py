from dataflows import Flow, load, dump_to_path, printer, set_type
from lib import dump_to_postgis
import csv
import os
import sys

csv.field_size_limit(sys.maxsize)

def ETL():
    
    url = 'https://db-data-recipes.sfo2.digitaloceanspaces.com/pipelines/db-zoningtaxlots/2019-05-28/datapackage.json'
    Flow(
        load(url, force_strings=True),
        dump_to_postgis()
    ).process()

if __name__ == "__main__":
    ETL()