#!/bin/bash
if [ -f .env ]
then
  export $(cat .env | sed 's/#.*//g' | xargs)
fi

echo "QC the zoning tax lot database"
psql $BUILD_ENGINE -f sql/qc_versioncomparisonfields.sql &
psql $BUILD_ENGINE -f sql/qc_bblsaddedandremoved.sql &
psql $BUILD_ENGINE -f sql/qc_bbldiffs.sql 

wait
source ./url_parse.sh $BUILD_ENGINE
mkdir -p output/qc_bbldiffs && 
    (cd output/qc_bbldiffs
    pgsql2shp -u $BUILD_USER -P $BUILD_PWD -h $BUILD_HOST -p $BUILD_PORT -f qc_bbldiffs $BUILD_DB \
    "SELECT * FROM bbldiffs WHERE geom IS NOT NULL"
    zip qc_bbldiffs.zip qc_bbldiffs.*
    rm -f qc_bbldiffs.cpg&
    rm -f qc_bbldiffs.dbf&
    rm -f qc_bbldiffs.prj&
    rm -f qc_bbldiffs.shp&
    rm -f qc_bbldiffs.shx&
    )

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
                        TO STDOUT DELIMITER ',' CSV HEADER;" > output/qc_bbldiffs.csv &
                              
psql $BUILD_ENGINE -c "\copy (SELECT * FROM bblcountchange) 
    TO STDOUT DELIMITER ',' CSV HEADER;" > output/qc_bbls_count_added_removed.csv &

psql $BUILD_ENGINE -c "\copy (SELECT * FROM frequencychanges) 
    TO STDOUT DELIMITER ',' CSV HEADER;" > output/qc_frequencychanges.csv &

psql $BUILD_ENGINE -c "\copy (SELECT * FROM ztl_qc_versioncomparisonnownullcount) 
    TO STDOUT DELIMITER ',' CSV HEADER;" > output/qc_versioncomparisonnownullcount.csv &

psql $BUILD_ENGINE -c "\copy (SELECT * FROM ztl_qc_versioncomparisoncount) 
    TO STDOUT DELIMITER ',' CSV HEADER;" > output/qc_versioncomparison.csv