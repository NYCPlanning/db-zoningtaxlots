from cook import Importer
import os
import sys
import pandas as pd
from sqlalchemy import create_engine
from multiprocessing import Pool, cpu_count

def ETL(table): 
    RECIPE_ENGINE = os.environ.get('RECIPE_ENGINE', '')
    BUILD_ENGINE=os.environ.get('BUILD_ENGINE', '')
    importer = Importer(RECIPE_ENGINE, BUILD_ENGINE)
    importer.import_table(schema_name=table)

if __name__ == "__main__":
    con = create_engine(os.getenv('BUILD_ENGINE'))    
    tables = ['dcp_commercialoverlay',
            'dcp_limitedheight',
            'dcp_mih',
            'dcp_specialpurpose',
            'dcp_specialpurposesubdistricts',
            'dcp_zoningtaxlots',
            'dcp_zoningmapamendments',
            'dcp_zoningmapindex',
            'dof_dtm',
            'dcp_zoningdistricts']
            
    with Pool(processes=cpu_count()) as pool:
        pool.map(ETL, tables)