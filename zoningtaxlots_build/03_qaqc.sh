#!/bin/sh
if [ -f .env ]
then
  export $(cat .env | sed 's/#.*//g' | xargs)
fi
# outputting ztl db shapefile
# export
 mkdir -p $(pwd)/output/zoningtaxlot_db && 
        cd $(pwd)/output/zoningtaxlot_db {
        pgsql2shp -u $BUILD_USER -P $BUILD_PWD -h $BUILD_HOST -p $BUILD_PORT -f zoningtaxlot_db $BUILD_DB \
        'SELECT a.*, b.geom 
        FROM dcp_zoning_taxlot_export a, dof_dtm b 
        WHERE a."BBL"=b.bbl AND b.geom IS NOT NULL;'
        cd -;}

echo "QC the zoning tax lot database"
psql $BUILD_ENGINE -f sql/qc_versioncomparisonfields.sql &
psql $BUILD_ENGINE -f sql/qc_bblsaddedandremoved.sql &
psql $BUILD_ENGINE -f sql/qc_bbldiffs.sql 

wait
mkdir -p $(pwd)/output/qc_bbldiffs && 
        cd $(pwd)/output/qc_bbldiffs {
        pgsql2shp -u $BUILD_USER -P $BUILD_PWD -h $BUILD_HOST -p $BUILD_PORT -f qc_bbldiffs $BUILD_DB \
        "SELECT * FROM bbldiffs WHERE geom IS NOT NULL"
        cd -;}

wait
psql $BUILD_ENGINE -f sql/qc_frequencycomparison.sql &
psql $BUILD_ENGINE -f sql/qc_frequencynownullcomparison.sql

wait
psql $BUILD_ENGINE -c "\copy (SELECT * FROM bbldiffs) 
                                    TO '$(pwd)/output/qc_bbldiffs.csv' 
                                    DELIMITER ',' CSV HEADER;" &

psql $BUILD_ENGINE -c "\copy (SELECT * FROM bblcountchange) 
                                    TO '$(pwd)/output/qc_bbls_count_added_removed.csv' 
                                    DELIMITER ',' CSV HEADER;" &

psql $BUILD_ENGINE -c "\copy (SELECT * FROM frequencychanges) 
                                    TO '$(pwd)/output/qc_frequencychanges.csv' 
                                    DELIMITER ',' CSV HEADER;" &

psql $BUILD_ENGINE -c "\copy (SELECT * FROM ztl_qc_versioncomparisonnownullcount) 
                                    TO '$(pwd)/output/qc_versioncomparisonnownullcount.csv' 
                                    DELIMITER ',' CSV HEADER;" &

psql $BUILD_ENGINE -c "\copy (SELECT * FROM ztl_qc_versioncomparisoncount) 
                                    TO '$(pwd)/output/qc_versioncomparison.csv' 
                                    DELIMITER ',' CSV HEADER;"
                                    
psql $BUILD_ENGINE -c "\copy (SELECT table_name, date FROM source_data_versions) 
                                    TO '$(pwd)/output/source_data_versions.csv' 
                                    DELIMITER ',' CSV HEADER;"