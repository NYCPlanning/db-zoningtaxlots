from cook import Importer
import os
import pandas as pd
from sqlalchemy import create_engine

def ETL():
    RECIPE_ENGINE = os.environ.get('RECIPE_ENGINE', '')
    BUILD_ENGINE=os.environ.get('BUILD_ENGINE', '')

    importer = Importer(RECIPE_ENGINE, BUILD_ENGINE)
    importer.import_table(schema_name='dcp_commercialoverlay')
    importer.import_table(schema_name='dcp_limitedheight')
    importer.import_table(schema_name='dcp_mih')
    importer.import_table(schema_name='dcp_specialpurpose')
    importer.import_table(schema_name='dcp_specialpurposesubdistricts')
    importer.import_table(schema_name='dcp_zoningtaxlots')
    importer.import_table(schema_name='dcp_zoningmapamendments')
    importer.import_table(schema_name='dcp_zoningmapindex')
    importer.import_table(schema_name='dof_dtm')
    importer.import_table(schema_name='dcp_zoningdistricts')
    
def LOAD_VERSION(): 
    RECIPE_ENGINE = create_engine(os.environ.get('RECIPE_ENGINE', ''))
    BUILD_ENGINE=create_engine(os.environ.get('BUILD_ENGINE', ''))
    df = pd.read_sql('''
    SELECT table_schema as table_name, max(TO_DATE(table_name, 'YYYY/MM/DD')) as date 
    FROM information_schema.tables 
    WHERE table_schema ~* 'dcp_commercialoverlay|dcp_limitedheight|dcp_mih|dcp_specialpurpose|dcp_specialpurposesubdistricts|dcp_zoningtaxlots|dcp_zoningmapamendments|dcp_zoningmapindex|dof_dtm|dcp_zoningdistricts' 
    AND table_name != 'latest'
    GROUP BY table_schema;
    ''', con=RECIPE_ENGINE)
    df.to_sql('source_data_versions', con=BUILD_ENGINE)
    
if __name__ == "__main__":
    ETL()
    LOAD_VERSION()