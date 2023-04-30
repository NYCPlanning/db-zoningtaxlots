import os
from sqlalchemy import create_engine

sql_engine = create_engine(os.environ("BUILD_ENGINE"))

input_datasets = [
    "dcp_commercialoverlay"
    "dcp_limitedheight"
    "dcp_specialpurpose"
    "dcp_specialpurposesubdistricts"
    "dcp_zoningmapamendments"
    "dof_dtm"
    "dcp_zoningdistricts"
    "dcp_zoningmapindex"
]