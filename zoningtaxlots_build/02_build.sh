#!/bin/bash
source config.sh

psql $BUILD_ENGINE -f sql/create_priority.sql &
psql $BUILD_ENGINE -f sql/preprocessing.sql
psql $BUILD_ENGINE -f sql/archive.sql 
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

wait
psql $BUILD_ENGINE -f sql/parks.sql
psql $BUILD_ENGINE -f sql/inzonechange.sql
psql $BUILD_ENGINE -f sql/correct_duplicatevalues.sql
psql $BUILD_ENGINE -f sql/correct_zoninggaps.sql
psql $BUILD_ENGINE -f sql/correct_invalidrecords.sql

echo "Inwood rezoning additional column"
psql $BUILD_ENGINE -f sql/inwoodrezoning.sql

echo "export final output"
psql $BUILD_ENGINE -f sql/export.sql

echo "archive final output"
pg_dump -t dcp_zoning_taxlot $BUILD_ENGINE | psql $EDM_DATA
psql $EDM_DATA -c "CREATE SCHEMA IF NOT EXISTS dcp_zoningtaxlots;";
psql $EDM_DATA -c "ALTER TABLE dcp_zoning_taxlot SET SCHEMA dcp_zoningtaxlots;";
psql $EDM_DATA -c "DROP TABLE IF EXISTS dcp_zoningtaxlots.\"$VERSION\";";
psql $EDM_DATA -c "ALTER TABLE dcp_zoningtaxlots.dcp_zoning_taxlot RENAME TO \"$VERSION\";";

mkdir -p output && (
  cd output
  psql $BUILD_ENGINE -c "\COPY (SELECT * FROM source_data_versions) 
    TO STDOUT DELIMITER ',' CSV HEADER;" > source_data_versions.csv
  psql $BUILD_ENGINE -c "\copy (SELECT * FROM dcp_zoning_taxlot_export)
    TO STDOUT DELIMITER ',' CSV HEADER;" > zoningtaxlot_db.csv
  echo "export unique value lookup tables"
  psql $BUILD_ENGINE -c "\copy (SELECT DISTINCT zonedist FROM dcp_zoningdistricts ORDER BY zonedist) 
    TO STDOUT DELIMITER ',' CSV HEADER;" > zoningtaxlot_zonedistricts.csv
  psql $BUILD_ENGINE -c "\copy (SELECT DISTINCT overlay FROM dcp_commercialoverlay ORDER BY overlay) 
    TO STDOUT DELIMITER ',' CSV HEADER;" > zoningtaxlot_commoverlay.csv
  psql $BUILD_ENGINE -c "\copy (SELECT DISTINCT sdname, sdlbl FROM dcp_specialpurpose ORDER BY sdname) 
    TO STDOUT DELIMITER ',' CSV HEADER;" > zoningtaxlot_specialdistricts.csv
  psql $BUILD_ENGINE -c "\copy (SELECT DISTINCT lhname, lhlbl FROM dcp_limitedheight ORDER BY lhname) 
    TO STDOUT DELIMITER ',' CSV HEADER;" > zoningtaxlot_limitedheight.csv
)