#!/bin/bash
source config.sh

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

# Generate source_data_versions table
psql $BUILD_ENGINE -1 -c "
  DROP TABLE IF EXISTS source_data_versions;
  CREATE TABLE source_data_versions as
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
"