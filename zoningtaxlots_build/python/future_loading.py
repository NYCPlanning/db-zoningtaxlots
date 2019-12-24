from dotenv import load_dotenv, find_dotenv
import requests
import os
import json 

load_dotenv(find_dotenv())

def ETL(schema_name, version='latest'):
    url=f'{os.environ["GATEWAY"]}/migrate'
    RECIPE_ENGINE=os.environ['RECIPE_ENGINE']
    BUILD_ENGINE=os.environ['BUILD_ENGINE']

    x = requests.post(url, json = 
                    {"src_engine": f"{RECIPE_ENGINE}",
                    "dst_engine": f"{BUILD_ENGINE}",
                    "src_schema_name": f"{schema_name}",
                    "dst_schema_name": "public",
                    "src_version": f"{version}",
                    "dst_version": f"{schema_name}"})

    r = json.loads(x.text)
    if r['status'] == 'success': 
        print(f'{schema_name} is loaded ...')
    else: 
        print(f'{schema_name} failed to load ...')

if __name__ == "__main__":
    ETL(schema_name='dcp_commercialoverlay')
    ETL(schema_name='dcp_limitedheight')
    ETL(schema_name='dcp_limitedheight')
    ETL(schema_name='dcp_specialpurpose')
    ETL(schema_name='dcp_specialpurposesubdistricts')
    ETL(schema_name='dcp_zoningtaxlots')
    ETL(schema_name='dcp_zoningmapamendments')
    ETL(schema_name='dcp_zoningmapindex')
    ETL(schema_name='dof_dtm')
    ETL(schema_name='dcp_zoningdistricts')