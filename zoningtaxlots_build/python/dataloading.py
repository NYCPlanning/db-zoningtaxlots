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
    (SELECT 'dcp_mih' as schema_name, v from dcp_mih limit 1)
    UNION
    (SELECT 'dcp_commercialoverlay' as schema_name, v from dcp_commercialoverlay limit 1)
    UNION
    (SELECT 'dcp_limitedheight' as schema_name, v from dcp_limitedheight limit 1)
    UNION
    (SELECT 'dcp_specialpurpose' as schema_name, v from dcp_specialpurpose limit 1)
    UNION
    (SELECT 'dcp_specialpurposesubdistricts' as schema_name, v from dcp_specialpurposesubdistricts limit 1)
    UNION
    (SELECT 'dcp_zoningmapamendments' as schema_name, v from dcp_zoningmapamendments limit 1)
    UNION
    (SELECT 'dof_dtm' as schema_name, v from dof_dtm limit 1)
    UNION
    (SELECT 'dcp_zoningdistricts' as schema_name, v from dcp_zoningdistricts limit 1);
    ''', con=RECIPE_ENGINE)
    df.to_sql('source_data_versions', con=BUILD_ENGINE)
    
if __name__ == "__main__":
    ETL()
    LOAD_VERSION()



