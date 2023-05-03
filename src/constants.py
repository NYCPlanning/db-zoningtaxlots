import os
from sqlalchemy import create_engine
from dotenv import load_dotenv

load_dotenv()

build_engine = create_engine(os.environ["BUILD_ENGINE"])
edm_data_engine = create_engine(os.environ["EDM_DATA"])

input_datasets = [
    "dcp_commercialoverlay",
    "dcp_limitedheight",
    "dcp_specialpurpose",
    "dcp_specialpurposesubdistricts",
    "dcp_zoningmapamendments",
    "dof_dtm",
    "dcp_zoningdistricts",
    "dcp_zoningmapindex",
]
