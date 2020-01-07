#!/bin/sh
if [ -f .env ]
then
  export $(cat .env | sed 's/#.*//g' | xargs)
fi
# outputting ztl db shapefile
# export
#  mkdir -p $(pwd)/output/zoningtaxlot_db && 
#         cd $(pwd)/output/zoningtaxlot_db {
#         pgsql2shp -u $BUILD_USER -P $BUILD_PWD -h $BUILD_HOST -p $BUILD_PORT -f zoningtaxlot_db $BUILD_DB \
#         'SELECT a.*, b.geom 
#         FROM dcp_zoning_taxlot_export a, dof_dtm b 
#         WHERE a."BBL"=b.bbl AND b.geom IS NOT NULL;'
#         zip zoningtaxlot_db.zip zoningtaxlot_db.*
#         rm zoningtaxlot_db.cpg&
#         rm zoningtaxlot_db.dbf&
#         rm zoningtaxlot_db.prj&
#         rm zoningtaxlot_db.shp&
#         rm zoningtaxlot_db.shx&
#         cd -;}

echo "QC the zoning tax lot database"
psql $BUILD_ENGINE -f sql/qc_versioncomparisonfields.sql &
psql $BUILD_ENGINE -f sql/qc_bblsaddedandremoved.sql &
psql $BUILD_ENGINE -f sql/qc_bbldiffs.sql 

wait
mkdir -p $(pwd)/output/qc_bbldiffs && 
        cd $(pwd)/output/qc_bbldiffs {
        pgsql2shp -u $BUILD_USER -P $BUILD_PWD -h $BUILD_HOST -p $BUILD_PORT -f qc_bbldiffs $BUILD_DB \
        "SELECT * FROM bbldiffs WHERE geom IS NOT NULL"
        rm qc_bbldiffs.zip
        zip qc_bbldiffs.zip qc_bbldiffs.*
        rm qc_bbldiffs.cpg&
        rm qc_bbldiffs.dbf&
        rm qc_bbldiffs.prj&
        rm qc_bbldiffs.shp&
        rm qc_bbldiffs.shx&
        cd -;}

wait
psql $BUILD_ENGINE -f sql/qc_frequencycomparison.sql &
psql $BUILD_ENGINE -f sql/qc_frequencynownullcomparison.sql

wait
psql $BUILD_ENGINE -c "\copy (SELECT boroughcode, taxblock,taxlot , bblnew ,zd1new , 
                                zd2new ,zd3new , zd4new ,co1new , co2new ,
                                sd1new , sd2new ,sd3new , lhdnew ,mihflag ,
                                mihoption , zmnnew , zmcnew , area, inzonechange , 
                                bblprev, zd1prev, zd2prev, zd3prev, zd4prev, 
                                co1prev, co2prev, sd1prev, sd2prev, sd3prev, 
                                lhdprev, zmnprev, zmcprev 
                                FROM bbldiffs)
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
                                    
psql $BUILD_ENGINE -c "\copy (SELECT schema_name, v FROM source_data_versions) 
                                    TO '$(pwd)/output/source_data_versions.csv' 
                                    DELIMITER ',' CSV HEADER;"