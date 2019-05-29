#!/bin/bash
start=$(date +'%T')
echo "Starting to build zoning tax lot database"
psql $DATAFLOWS_DB_ENGINE -f sql/preprocessing.sql
psql $DATAFLOWS_DB_ENGINE -f sql/archive.sql
psql $DATAFLOWS_DB_ENGINE -f sql/create.sql
psql $DATAFLOWS_DB_ENGINE -f sql/bbl.sql

# psql $DATAFLOWS_DB_ENGINE -f sql/area_zoningdistrict.sql
# psql $DATAFLOWS_DB_ENGINE -c "\copy (SELECT * FROM lotzoneperorder ORDER BY bbl) 
#                                 TO '/home/zoningtaxlots_build/output/intermediate_lotzoneperorder.csv' 
#                                 DELIMITER ',' CSV HEADER;"

psql $DATAFLOWS_DB_ENGINE -f sql/area_commercialoverlay.sql
psql $DATAFLOWS_DB_ENGINE -c "\copy (SELECT * FROM commoverlayperorder ORDER BY bbl) 
                                TO '/home/zoningtaxlots_build/output/intermediate_commoverlayperorder.csv' 
                                DELIMITER ',' CSV HEADER;"

psql $DATAFLOWS_DB_ENGINE -f sql/area_specialdistrict.sql
psql $DATAFLOWS_DB_ENGINE -c "\copy (SELECT * FROM specialpurposeperorder ORDER BY bbl) 
                                TO '/home/zoningtaxlots_build/output/intermediate_specialpurposeperorder.csv' 
                                DELIMITER ',' CSV HEADER;"

psql $DATAFLOWS_DB_ENGINE -f sql/area_limitedheight.sql
psql $DATAFLOWS_DB_ENGINE -c "\copy (SELECT * FROM limitedheightperorder ORDER BY bbl) 
                                TO '/home/zoningtaxlots_build/output/intermediate_limitedheightperorder.csv' 
                                DELIMITER ',' CSV HEADER;"

psql $DATAFLOWS_DB_ENGINE -f sql/area_zoningmap.sql
psql $DATAFLOWS_DB_ENGINE -c "\copy (SELECT * FROM zoningmapperorder ORDER BY bbl) 
                                TO '/home/zoningtaxlots_build/output/intermediate_zoningmapperorder.csv' 
                                DELIMITER ',' CSV HEADER;"

psql $DATAFLOWS_DB_ENGINE -f sql/area_mih.sql
psql $DATAFLOWS_DB_ENGINE -c "\copy (SELECT * FROM mihperorder ORDER BY bbl) 
                                TO '/home/zoningtaxlots_build/output/intermediate_mihperorder.csv' 
                                DELIMITER ',' CSV HEADER;"

psql $DATAFLOWS_DB_ENGINE -f sql/parks.sql
psql $DATAFLOWS_DB_ENGINE -f sql/inzonechange.sql
psql $DATAFLOWS_DB_ENGINE -f sql/correct_duplicatevalues.sql
psql $DATAFLOWS_DB_ENGINE -f sql/correct_zoninggaps.sql
psql $DATAFLOWS_DB_ENGINE -f sql/correct_invalid.sql

echo "export final output"
psql $DATAFLOWS_DB_ENGINE -f sql/export.sql
psql $DATAFLOWS_DB_ENGINE -c "\copy (SELECT * FROM dcp_zoning_taxlot_export)
                                TO '/home/zoningtaxlots_build/output/zoningtaxlot_db.csv' 
                                DELIMITER ',' CSV HEADER;"

echo "export unique value lookup tables"
psql $DATAFLOWS_DB_ENGINE -c "\copy (SELECT DISTINCT zonedist FROM dcp_zoningdistricts ORDER BY zonedist) 
                                TO '/home/zoningtaxlots_build/output/zoningtaxlot_zonedistricts.csv' 
                                DELIMITER ',' CSV HEADER;"

psql $DATAFLOWS_DB_ENGINE -c "\copy (SELECT DISTINCT overlay FROM dcp_commercialoverlay ORDER BY overlay) 
                                TO '/home/zoningtaxlots_build/output/zoningtaxlot_commoverlay.csv' 
                                DELIMITER ',' CSV HEADER;"

psql $DATAFLOWS_DB_ENGINE -c "\copy (SELECT DISTINCT sdname, sdlbl FROM dcp_specialpurpose ORDER BY sdname) 
                                TO '/home/zoningtaxlots_build/output/zoningtaxlot_specialdistricts.csv' 
                                DELIMITER ',' CSV HEADER;"

psql $DATAFLOWS_DB_ENGINE -c "\copy (SELECT DISTINCT lhname, lhlbl FROM dcp_limitedheight ORDER BY lhname) 
                                TO '/home/zoningtaxlots_build/output/zoningtaxlot_limitedheight.csv' 
                                DELIMITER ',' CSV HEADER;"    
echo "Build is done!"