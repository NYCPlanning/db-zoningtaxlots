#!/bin/bash
source config.sh

psql $BUILD_ENGINE -f sql/create_priority.sql &
psql $BUILD_ENGINE -f sql/preprocessing.sql
psql $BUILD_ENGINE -f sql/create.sql 
psql $BUILD_ENGINE -f sql/bbl.sql

wait
psql $BUILD_ENGINE -f sql/area_zoningdistrict_create.sql &
psql $BUILD_ENGINE -f sql/area_commercialoverlay.sql &
psql $BUILD_ENGINE -f sql/area_specialdistrict.sql &
psql $BUILD_ENGINE -f sql/area_limitedheight.sql &
psql $BUILD_ENGINE -f sql/area_zoningmap.sql

wait
psql $BUILD_ENGINE -f sql/area_zoningdistrict.sql 
psql $BUILD_ENGINE -f sql/parks.sql
psql $BUILD_ENGINE -f sql/inzonechange.sql
psql $BUILD_ENGINE -f sql/correct_duplicatevalues.sql
psql $BUILD_ENGINE -f sql/correct_zoninggaps.sql
psql $BUILD_ENGINE -f sql/correct_invalidrecords.sql

echo "archive final output"
pg_dump -t dcp_zoning_taxlot $BUILD_ENGINE | psql $EDM_DATA

psql $EDM_DATA -c "
  CREATE SCHEMA IF NOT EXISTS dcp_zoningtaxlots;
  ALTER TABLE dcp_zoning_taxlot SET SCHEMA dcp_zoningtaxlots;
  DROP TABLE IF EXISTS dcp_zoningtaxlots.\"$VERSION\";
  ALTER TABLE dcp_zoningtaxlots.dcp_zoning_taxlot RENAME TO \"$VERSION\";
"