import requests
import os
import json
from sqlalchemy import create_engine
from datetime import datetime
from dotenv import load_dotenv, find_dotenv
load_dotenv(find_dotenv())

def ARCHIVE(schema_name, version):
    url = f'{os.environ["GATEWAY"]}/migrate'
    EDM_DATA = os.environ['EDM_DATA']
    BUILD_ENGINE = os.environ['BUILD_ENGINE']

    x = requests.post(url, json = 
                    {"src_engine": f"{BUILD_ENGINE}",
                    "dst_engine": f"{EDM_DATA}",
                    "src_schema_name": "public",
                    "dst_schema_name": f"{schema_name}",
                    "src_version": f"{schema_name}",
                    "dst_version": f"{version}"})

    r = json.loads(x.text)
    if r['status'] == 'success':
        print(f'{schema_name} is loaded ...')
        CREATE_VIEW(EDM_DATA, 
            r['config']['dst_schema_name'], 
            r['config']['dst_version'])
    else: 
        print(f'{schema_name} failed to load ...')

def CREATE_VIEW(engine, schema_name, version):
    con = create_engine(engine)
    con.execute(f'DROP VIEW IF EXISTS {schema_name}.latest;')
    con.execute(f'CREATE VIEW {schema_name}.latest as (\
        SELECT \'{version}\' as v, * from {schema_name}."{version}");')
    print(f'{schema_name}.{version} is tagged as latest ...')

if __name__ == "__main__":
    date = datetime.today().strftime("%Y/%m/%d")
    ARCHIVE(schema_name='dcp_zoningtaxlots', version=date)