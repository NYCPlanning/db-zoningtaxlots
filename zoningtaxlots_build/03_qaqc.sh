#!/bin/bash
# outputting ztl db shapefile
# export
docker exec ztl sh -c "
    mkdir -p output/zoningtaxlot_db && 
        cd output/zoningtaxlot_db {
        pgsql2shp -u postgres -h localhost -f zoningtaxlot_db postgres \
        'SELECT a.*, b.geom 
        FROM dcp_zoning_taxlot_export a, dof_dtm b 
        WHERE a.\"BBL\"=b.bbl AND b.geom IS NOT NULL;'
        cd -;}"

start=$(date +'%T')
echo "QC the zoning tax lot database"
docker exec ztl psql -U postgres -h localhost -f sql/qc_versioncomparisonfields.sql &
docker exec ztl psql -U postgres -h localhost -f sql/qc_bblsaddedandremoved.sql &
docker exec ztl psql -U postgres -h localhost -f sql/qc_bbldiffs.sql 

wait
docker exec ztl sh -c "
    mkdir -p /home/zoningtaxlots_build/output/qc_bbldiffs && 
        cd /home/zoningtaxlots_build/output/qc_bbldiffs {
        pgsql2shp -u postgres -h localhost -f qc_bbldiffs postgres \
        \"SELECT * FROM bbldiffs WHERE geom IS NOT NULL\"
        cd -;}"

wait
docker exec ztl psql -U postgres -h localhost -f sql/qc_frequencycomparison.sql &
docker exec ztl psql -U postgres -h localhost -f sql/qc_frequencynownullcomparison.sql

wait
docker exec ztl psql -U postgres -h localhost -c "\copy (SELECT * FROM bbldiffs) 
                                    TO '/home/zoningtaxlots_build/output/qc_bbldiffs.csv' 
                                    DELIMITER ',' CSV HEADER;" &

docker exec ztl psql -U postgres -h localhost -c "\copy (SELECT * FROM bblcountchange) 
                                    TO '/home/zoningtaxlots_build/output/qc_bbls_count_added_removed.csv' 
                                    DELIMITER ',' CSV HEADER;" &

docker exec ztl psql -U postgres -h localhost -c "\copy (SELECT * FROM frequencychanges) 
                                    TO '/home/zoningtaxlots_build/output/qc_frequencychanges.csv' 
                                    DELIMITER ',' CSV HEADER;" &

docker exec ztl psql -U postgres -h localhost -c "\copy (SELECT * FROM ztl_qc_versioncomparisonnownullcount) 
                                    TO '/home/zoningtaxlots_build/output/qc_versioncomparisonnownullcount.csv' 
                                    DELIMITER ',' CSV HEADER;" &

docker exec ztl psql -U postgres -h localhost -c "\copy (SELECT * FROM ztl_qc_versioncomparisoncount) 
                                    TO '/home/zoningtaxlots_build/output/qc_versioncomparison.csv' 
                                    DELIMITER ',' CSV HEADER;"
                                    
docker exec ztl psql -U postgres -h localhost -c "\copy (SELECT table_name, date FROM source_data_versions) 
                                    TO '/home/zoningtaxlots_build/output/source_data_versions.csv' 
                                    DELIMITER ',' CSV HEADER;"