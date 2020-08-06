#!/bin/bash
source config.sh

psql $EDM_DATA -v VERSION=$VERSION -f sql/qaqc/frequency.sql
psql $EDM_DATA -c "\copy (SELECT * FROM dcp_zoningtaxlots.qaqc_frequency order by version::timestamp) 
    TO STDOUT DELIMITER ',' CSV HEADER;" > output/qaqc_frequency.csv

psql $EDM_DATA -v VERSION=$VERSION -v VERSION_PREV=$VERSION_PREV -f sql/qaqc/bbl.sql
psql $EDM_DATA -c "\copy (SELECT * FROM dcp_zoningtaxlots.qaqc_bbl order by version::timestamp) 
    TO STDOUT DELIMITER ',' CSV HEADER;" > output/qaqc_bbl.csv
    
psql $EDM_DATA -v VERSION=$VERSION -v VERSION_PREV=$VERSION_PREV -f sql/qaqc/mismatch.sql
psql $EDM_DATA -c "\copy (SELECT * FROM dcp_zoningtaxlots.qaqc_mismatch order by version::timestamp) 
    TO STDOUT DELIMITER ',' CSV HEADER;" > output/qaqc_mismatch.csv

psql $EDM_DATA -v VERSION=$VERSION -v VERSION_PREV=$VERSION_PREV -f sql/qaqc/out_bbldiffs.sql |
psql $BUILD_ENGINE -f sql/qaqc/in_bbldiffs.sql