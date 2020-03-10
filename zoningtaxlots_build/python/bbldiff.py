import geopandas as gpd 
import pandas as pd
from sqlalchemy import create_engine
from datetime import datetime
import os 

RECIPE_ENGINE = os.environ.get('RECIPE_ENGINE', '')

conn = create_engine(RECIPE_ENGINE)
versions = [i[0] for i in conn.execute('''
            SELECT table_name
            FROM information_schema.tables 
            WHERE table_schema = 'dof_dtm'
            AND table_name !~*'latest';
            ''').fetchall()]

latest = max(versions, key=lambda x: datetime.strptime(x, '%Y/%m/%d'))
prev = max([i for i in versions if i != latest], 
           key=lambda x: datetime.strptime(x, '%Y/%m/%d'))

df = pd.read_csv('output/qc_bbldiffs.csv', dtype=str)
bbls = '|'.join(df.bblnew.to_list())

new = gpd.read_postgis(f'select bbl, wkb_geometry from dof_dtm.{latest} where bbl ~* \'{bbls}\'', con=conn, geom_col='wkb_geometry')
old = gpd.read_postgis(f'select bbl, wkb_geometry from dof_dtm.{prev} where bbl ~* \'{bbls}\'', con=conn, geom_col='wkb_geometry')

new.to_file("output/new_bbl.geojson", driver='GeoJSON')
old.to_file("output/old_bbl.geojson", driver='GeoJSON')
