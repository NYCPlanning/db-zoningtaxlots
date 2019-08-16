from cook import Importer
import os

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

if __name__ == "__main__":
    ETL()