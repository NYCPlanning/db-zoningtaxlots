#!/bin/bash
source bash/config.sh

psql $BUILD_ENGINE -q -c "
  DROP TABLE IF EXISTS versions;
  CREATE TABLE versions ( 
    datasource text, 
    version text 
  );
"

# Import Data
import dcp_commercialoverlay &
import dcp_limitedheight &
import dcp_specialpurpose &
import dcp_specialpurposesubdistricts &
import dcp_zoningmapamendments &
import dof_dtm &
import dcp_zoningdistricts &
import dcp_zoningmapindex &
wait

rm -rf .library

# Generate source_data_versions table
psql $BUILD_ENGINE -1 -c "
  DROP TABLE IF EXISTS source_data_versions;
  SELECT 
    datasource as schema_name, 
    version as v
  INTO source_data_versions
  FROM versions;
"