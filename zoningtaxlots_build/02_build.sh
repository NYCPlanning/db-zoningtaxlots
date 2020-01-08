#!/bin/bash
if [ -f .env ]
then
  export $(cat .env | sed 's/#.*//g' | xargs)
fi

echo "Starting to build zoning tax lot database"
psql $BUILD_ENGINE -f sql/create_priority.sql &
psql $BUILD_ENGINE -f sql/preprocessing.sql
psql $BUILD_ENGINE -f sql/archive.sql 
psql $BUILD_ENGINE -f sql/create.sql 
psql $BUILD_ENGINE -f sql/bbl.sql

wait
psql $BUILD_ENGINE -f sql/area_zoningdistrict_mn.sql &
psql $BUILD_ENGINE -f sql/area_zoningdistrict_bk.sql &
psql $BUILD_ENGINE -f sql/area_zoningdistrict_bx.sql &
psql $BUILD_ENGINE -f sql/area_zoningdistrict_si.sql &
psql $BUILD_ENGINE -f sql/area_zoningdistrict_qn.sql &
psql $BUILD_ENGINE -f sql/area_commercialoverlay.sql &
psql $BUILD_ENGINE -f sql/area_specialdistrict.sql &
psql $BUILD_ENGINE -f sql/area_limitedheight.sql &
psql $BUILD_ENGINE -f sql/area_zoningmap.sql & 
psql $BUILD_ENGINE -f sql/area_mih.sql

wait
psql $BUILD_ENGINE -f sql/area_zoningdistrict.sql 

wait
psql $BUILD_ENGINE -c "\copy (SELECT * FROM zoningmapperorder ORDER BY bbl) 
                                TO '$(pwd)/output/intermediate_zoningmapperorder.csv' 
                                DELIMITER ',' CSV HEADER;"&

psql $BUILD_ENGINE -c "\copy (SELECT * FROM limitedheightperorder ORDER BY bbl) 
                                TO '$(pwd)/output/intermediate_limitedheightperorder.csv' 
                                DELIMITER ',' CSV HEADER;"&

psql $BUILD_ENGINE -c "\copy (SELECT * FROM specialpurposeperorder ORDER BY bbl) 
                                TO '$(pwd)/output/intermediate_specialpurposeperorder.csv' 
                                DELIMITER ',' CSV HEADER;"&

psql $BUILD_ENGINE -c "\copy (SELECT * FROM commoverlayperorder ORDER BY bbl) 
                                TO '$(pwd)/output/intermediate_commoverlayperorder.csv' 
                                DELIMITER ',' CSV HEADER;"&

psql $BUILD_ENGINE -c "\copy (SELECT * FROM lotzoneperorder ORDER BY bbl) 
                                TO '$(pwd)/output/intermediate_lotzoneperorder.csv' 
                                DELIMITER ',' CSV HEADER;"&

psql $BUILD_ENGINE -c "\copy (SELECT * FROM mihperorder ORDER BY bbl) 
                                TO '$(pwd)/output/intermediate_mihperorder.csv' 
                                DELIMITER ',' CSV HEADER;"

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
                                TO '$(pwd)/output/zoningtaxlot_db.csv' 
                                DELIMITER ',' CSV HEADER;" &

echo "export unique value lookup tables"
psql $BUILD_ENGINE -c "\copy (SELECT DISTINCT zonedist FROM dcp_zoningdistricts ORDER BY zonedist) 
                                TO '$(pwd)/output/zoningtaxlot_zonedistricts.csv' 
                                DELIMITER ',' CSV HEADER;" &

psql $BUILD_ENGINE -c "\copy (SELECT DISTINCT overlay FROM dcp_commercialoverlay ORDER BY overlay) 
                                TO '$(pwd)/output/zoningtaxlot_commoverlay.csv' 
                                DELIMITER ',' CSV HEADER;" &

psql $BUILD_ENGINE -c "\copy (SELECT DISTINCT sdname, sdlbl FROM dcp_specialpurpose ORDER BY sdname) 
                                TO '$(pwd)/output/zoningtaxlot_specialdistricts.csv' 
                                DELIMITER ',' CSV HEADER;" &

psql $BUILD_ENGINE -c "\copy (SELECT DISTINCT lhname, lhlbl FROM dcp_limitedheight ORDER BY lhname) 
                                TO '$(pwd)/output/zoningtaxlot_limitedheight.csv' 
                                DELIMITER ',' CSV HEADER;"
                                
wait
echo "Build is done!"