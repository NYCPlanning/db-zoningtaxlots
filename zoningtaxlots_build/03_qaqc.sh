#!/bin/bash
if [ -f .env ]
then
  export $(cat .env | sed 's/#.*//g' | xargs)
fi
DATE=$(date "+%Y/%m/%d")
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
    echo "$DATE" > version.txt
    zip qc_bbldiffs.zip *
    ls | grep -v qc_bbldiffs.zip | xargs rm
    )
    
echo "$DATE" > version.txt

wait
psql $BUILD_ENGINE -f sql/qc_frequencycomparison.sql &
psql $BUILD_ENGINE -f sql/qc_frequencynownullcomparison.sql

wait
psql $BUILD_ENGINE -c "\copy (SELECT jsonb_build_object(
        'type',     'FeatureCollection',
        'features', jsonb_agg(feature)
        )
        FROM (
        SELECT jsonb_build_object(
            'type',       'Feature',
            'geometry',   ST_AsGeoJSON(geom)::jsonb,
            'properties', to_jsonb(inputs) - 'gid' - 'geom'
        ) AS feature
        FROM (
            SELECT * FROM bbldiffs
        ) inputs
        ) features) to STDOUT" > output/qc_bbldiffs.json &

psql $BUILD_ENGINE -c "\copy (SELECT boroughcode, taxblock,taxlot , bblnew ,zd1new , 
                                zd2new ,zd3new , zd4new ,co1new , co2new ,
                                sd1new , sd2new ,sd3new , lhdnew ,mihflag ,
                                mihoption , zmnnew , zmcnew , area, inzonechange , 
                                bblprev, zd1prev, zd2prev, zd3prev, zd4prev, 
                                co1prev, co2prev, sd1prev, sd2prev, sd3prev, 
                                lhdprev, zmnprev, zmcprev, st_x(ST_Centroid(geom)) as longitude, 
                                st_y(ST_Centroid(geom)) as latitude
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

echo "$DATE" > output/version.txt