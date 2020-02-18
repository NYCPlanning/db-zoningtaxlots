#!/bin/bash
if [ -f .env ]
then
  export $(cat .env | sed 's/#.*//g' | xargs)
fi

echo "Starting to build zoning tax lot database"
psql $BUILD_ENGINE -c "
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
mkdir -p output
psql $BUILD_ENGINE -c "\COPY (SELECT * FROM source_data_versions) 
    TO STDOUT DELIMITER ',' CSV HEADER;" > output/source_data_versions.csv
# psql $BUILD_ENGINE -c "\copy (SELECT * FROM zoningmapperorder ORDER BY bbl) 
#     TO STDOUT DELIMITER ',' CSV HEADER;" > output/intermediate_zoningmapperorder.csv
# psql $BUILD_ENGINE -c "\copy (SELECT * FROM limitedheightperorder ORDER BY bbl) 
#     TO STDOUT DELIMITER ',' CSV HEADER;" > output/intermediate_limitedheightperorder.csv
# psql $BUILD_ENGINE -c "\copy (SELECT * FROM specialpurposeperorder ORDER BY bbl) 
#     TO STDOUT DELIMITER ',' CSV HEADER;" > output/intermediate_specialpurposeperorder.csv
# psql $BUILD_ENGINE -c "\copy (SELECT * FROM commoverlayperorder ORDER BY bbl) 
#     TO STDOUT DELIMITER ',' CSV HEADER;" > output/intermediate_commoverlayperorder.csv
# psql $BUILD_ENGINE -c "\copy (SELECT * FROM lotzoneperorder ORDER BY bbl) 
#     TO STDOUT DELIMITER ',' CSV HEADER;" > output/intermediate_lotzoneperorder.csv
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

psql $BUILD_ENGINE -c "\copy (SELECT * FROM dcp_zoning_taxlot_export)
  TO STDOUT DELIMITER ',' CSV HEADER;" > output/zoningtaxlot_db.csv
echo "export unique value lookup tables"
psql $BUILD_ENGINE -c "\copy (SELECT DISTINCT zonedist FROM dcp_zoningdistricts ORDER BY zonedist) 
  TO STDOUT DELIMITER ',' CSV HEADER;" > output/zoningtaxlot_zonedistricts.csv
psql $BUILD_ENGINE -c "\copy (SELECT DISTINCT overlay FROM dcp_commercialoverlay ORDER BY overlay) 
  TO STDOUT DELIMITER ',' CSV HEADER;" > output/zoningtaxlot_commoverlay.csv
psql $BUILD_ENGINE -c "\copy (SELECT DISTINCT sdname, sdlbl FROM dcp_specialpurpose ORDER BY sdname) 
  TO STDOUT DELIMITER ',' CSV HEADER;" > output/zoningtaxlot_specialdistricts.csv
psql $BUILD_ENGINE -c "\copy (SELECT DISTINCT lhname, lhlbl FROM dcp_limitedheight ORDER BY lhname) 
  TO STDOUT DELIMITER ',' CSV HEADER;" > output/zoningtaxlot_limitedheight.csv