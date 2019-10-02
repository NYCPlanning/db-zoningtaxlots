#!/bin/bash
start=$(date +'%T')
echo "Starting to build zoning tax lot database"
psql -h localhost -U postgres -f sql/create_priority.sql
psql -h localhost -U postgres -f sql/preprocessing.sql
psql -h localhost -U postgres -f sql/archive.sql
psql -h localhost -U postgres -f sql/create.sql
psql -h localhost -U postgres -f sql/bbl.sql

wait
psql -h localhost -U postgres -f sql/area_zoningdistrict_mn.sql &
psql -h localhost -U postgres -f sql/area_zoningdistrict_bk.sql &
psql -h localhost -U postgres -f sql/area_zoningdistrict_bx.sql &
psql -h localhost -U postgres -f sql/area_zoningdistrict_si.sql &
psql -h localhost -U postgres -f sql/area_zoningdistrict_qn.sql &
psql -h localhost -U postgres -f sql/area_commercialoverlay.sql &
psql -h localhost -U postgres -f sql/area_specialdistrict.sql &
psql -h localhost -U postgres -f sql/area_limitedheight.sql &
psql -h localhost -U postgres -f sql/area_zoningmap.sql & 
psql -h localhost -U postgres -f sql/area_mih.sql

wait
psql -h localhost -U postgres -f sql/area_zoningdistrict.sql

wait
psql -h localhost -U postgres -c "\copy (SELECT * FROM zoningmapperorder ORDER BY bbl) 
                                TO '/home/zoningtaxlots_build/output/intermediate_zoningmapperorder.csv' 
                                DELIMITER ',' CSV HEADER;"&

psql -h localhost -U postgres -c "\copy (SELECT * FROM limitedheightperorder ORDER BY bbl) 
                                TO '/home/zoningtaxlots_build/output/intermediate_limitedheightperorder.csv' 
                                DELIMITER ',' CSV HEADER;"&

psql -h localhost -U postgres -c "\copy (SELECT * FROM specialpurposeperorder ORDER BY bbl) 
                                TO '/home/zoningtaxlots_build/output/intermediate_specialpurposeperorder.csv' 
                                DELIMITER ',' CSV HEADER;"&

psql -h localhost -U postgres -c "\copy (SELECT * FROM commoverlayperorder ORDER BY bbl) 
                                TO '/home/zoningtaxlots_build/output/intermediate_commoverlayperorder.csv' 
                                DELIMITER ',' CSV HEADER;"&

psql -h localhost -U postgres -c "\copy (SELECT * FROM lotzoneperorder ORDER BY bbl) 
                                TO '/home/zoningtaxlots_build/output/intermediate_lotzoneperorder.csv' 
                                DELIMITER ',' CSV HEADER;"&

psql -h localhost -U postgres -c "\copy (SELECT * FROM mihperorder ORDER BY bbl) 
                                TO '/home/zoningtaxlots_build/output/intermediate_mihperorder.csv' 
                                DELIMITER ',' CSV HEADER;"

wait

psql -h localhost -U postgres -f sql/parks.sql
psql -h localhost -U postgres -f sql/inzonechange.sql
psql -h localhost -U postgres -f sql/correct_duplicatevalues.sql
psql -h localhost -U postgres -f sql/correct_zoninggaps.sql
psql -h localhost -U postgres -f sql/correct_invalidrecords.sql

echo "export final output"
psql -h localhost -U postgres -f sql/export.sql
psql -h localhost -U postgres -c "\copy (SELECT * FROM dcp_zoning_taxlot_export)
                                TO '/home/zoningtaxlots_build/output/zoningtaxlot_db.csv' 
                                DELIMITER ',' CSV HEADER;"

echo "export unique value lookup tables"
psql -h localhost -U postgres -c "\copy (SELECT DISTINCT zonedist FROM dcp_zoningdistricts ORDER BY zonedist) 
                                TO '/home/zoningtaxlots_build/output/zoningtaxlot_zonedistricts.csv' 
                                DELIMITER ',' CSV HEADER;" &

psql -h localhost -U postgres -c "\copy (SELECT DISTINCT overlay FROM dcp_commercialoverlay ORDER BY overlay) 
                                TO '/home/zoningtaxlots_build/output/zoningtaxlot_commoverlay.csv' 
                                DELIMITER ',' CSV HEADER;" &

psql -h localhost -U postgres -c "\copy (SELECT DISTINCT sdname, sdlbl FROM dcp_specialpurpose ORDER BY sdname) 
                                TO '/home/zoningtaxlots_build/output/zoningtaxlot_specialdistricts.csv' 
                                DELIMITER ',' CSV HEADER;" &

psql -h localhost -U postgres -c "\copy (SELECT DISTINCT lhname, lhlbl FROM dcp_limitedheight ORDER BY lhname) 
                                TO '/home/zoningtaxlots_build/output/zoningtaxlot_limitedheight.csv' 
                                DELIMITER ',' CSV HEADER;" &
echo "Build is done!"