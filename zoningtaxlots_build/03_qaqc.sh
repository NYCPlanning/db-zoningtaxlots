#!/bin/bash
source config.sh

psql $BUILD_ENGINE -f sql/export.sql
psql $EDM_DATA -v VERSION=$VERSION -f sql/qaqc/frequency.sql
psql $EDM_DATA -v VERSION=$VERSION -v VERSION_PREV=$VERSION_PREV -f sql/qaqc/bbl.sql
psql $EDM_DATA -v VERSION=$VERSION -v VERSION_PREV=$VERSION_PREV -f sql/qaqc/mismatch.sql
psql $EDM_DATA -v VERSION=$VERSION -v VERSION_PREV=$VERSION_PREV -f sql/qaqc/out_bbldiffs.sql | 
    psql $BUILD_ENGINE -f sql/qaqc/in_bbldiffs.sql

rm -rf output && mkdir -p output
(
    cd output

    psql $BUILD_ENGINE -c "\COPY (
        SELECT * FROM source_data_versions
    ) TO STDOUT DELIMITER ',' CSV HEADER;" > source_data_versions.csv &
    
    psql $BUILD_ENGINE -c "\copy (
        SELECT * FROM dcp_zoning_taxlot_export
    )TO STDOUT DELIMITER ',' CSV HEADER;" > zoningtaxlot_db.csv &

    psql $BUILD_ENGINE -c "\copy (
        SELECT DISTINCT zonedist 
        FROM dcp_zoningdistricts 
        ORDER BY zonedist
    ) TO STDOUT DELIMITER ',' CSV HEADER;" > zoningtaxlot_zonedistricts.csv &
    
    psql $BUILD_ENGINE -c "\copy (
        SELECT DISTINCT overlay 
        FROM dcp_commercialoverlay 
        ORDER BY overlay
    ) TO STDOUT DELIMITER ',' CSV HEADER;" > zoningtaxlot_commoverlay.csv &
    
    psql $BUILD_ENGINE -c "\copy (
        SELECT DISTINCT sdname, sdlbl 
        FROM dcp_specialpurpose 
        ORDER BY sdname
    ) TO STDOUT DELIMITER ',' CSV HEADER;" > zoningtaxlot_specialdistricts.csv &
    
    psql $BUILD_ENGINE -c "\copy (
        SELECT DISTINCT lhname, lhlbl
        FROM dcp_limitedheight 
        ORDER BY lhname
    ) TO STDOUT DELIMITER ',' CSV HEADER;" > zoningtaxlot_limitedheight.csv &

    psql $EDM_DATA -c "\copy (
    SELECT * FROM dcp_zoningtaxlots.qaqc_frequency 
    order by version::timestamp
    ) TO STDOUT DELIMITER ',' CSV HEADER;" > qaqc_frequency.csv &

    psql $EDM_DATA -c "\copy (
    SELECT * FROM dcp_zoningtaxlots.qaqc_bbl 
    order by version::timestamp
    ) TO STDOUT DELIMITER ',' CSV HEADER;" > qaqc_bbl.csv &

    psql $EDM_DATA -c "\copy (
    SELECT * FROM dcp_zoningtaxlots.qaqc_mismatch 
    order by version::timestamp
    ) TO STDOUT DELIMITER ',' CSV HEADER;" > qaqc_mismatch.csv &

    psql $BUILD_ENGINE -c "\copy (
    SELECT boroughcode, taxblock,taxlot , bblnew ,zd1new , 
        zd2new ,zd3new , zd4new ,co1new , co2new ,
        sd1new , sd2new ,sd3new , lhdnew zmnnew , 
        zmcnew , area, inzonechange , 
        bblprev, zd1prev, zd2prev, zd3prev, zd4prev, 
        co1prev, co2prev, sd1prev, sd2prev, sd3prev, 
        lhdprev, zmnprev, zmcprev
    FROM qc_bbldiffs
    ) TO STDOUT DELIMITER ',' CSV HEADER;" > qc_bbldiffs.csv &

    SHP_export qc_bbldiffs

    echo "$DATE" > version.txt
    wait
)

psql -q $EDM_DATA -v VERSION=$VERSION -v VERSION_PREV=$VERSION_PREV \
    -f sql/qaqc/versioncomparison.sql > output/qc_versioncomparison.csv

psql -q $EDM_DATA -v VERSION=$VERSION -v VERSION_PREV=$VERSION_PREV \
    -f sql/qaqc/null.sql > output/qaqc_null.csv

Upload $DATE
Upload latest