#!/bin/bash
if [ -f .env ]
then
  export $(cat .env | sed 's/#.*//g' | xargs)
fi

pg_dump -t dcp_zoning_taxlot $BUILD_ENGINE | psql $EDM_DATA

DATE=$(date "+%Y/%m/01")
# VERSION=$DATE
# VERSION_PREV=$(date --date="$(date "+%Y/%m/01") - 1 month" "+%Y/%m/01")
VERSION='2020/07/01'
VERSION_PREV='2020/06/01'

psql $EDM_DATA -c "CREATE SCHEMA IF NOT EXISTS dcp_zoningtaxlots;";
psql $EDM_DATA -c "ALTER TABLE dcp_zoning_taxlot SET SCHEMA dcp_zoningtaxlots;";
psql $EDM_DATA -c "DROP TABLE IF EXISTS dcp_zoningtaxlots.\"$VERSION\";";
psql $EDM_DATA -c "ALTER TABLE dcp_zoningtaxlots.dcp_zoning_taxlot RENAME TO \"$VERSION\";";

psql $EDM_DATA -v VERSION=$VERSION -f sql/qaqc/frequency.sql
psql $EDM_DATA -c "\copy (SELECT * FROM dcp_zoningtaxlots.qaqc_frequency order by version::timestamp) 
    TO STDOUT DELIMITER ',' CSV HEADER;" > output/qaqc_frequency.csv

psql $EDM_DATA -v VERSION=$VERSION -v VERSION_PREV=$VERSION_PREV -f sql/qaqc/bbl.sql
psql $EDM_DATA -c "\copy (SELECT * FROM dcp_zoningtaxlots.qaqc_bbl order by version::timestamp) 
    TO STDOUT DELIMITER ',' CSV HEADER;" > output/qaqc_bbl.csv
    
psql $EDM_DATA -v VERSION=$VERSION -v VERSION_PREV=$VERSION_PREV -f sql/qaqc/mismatch.sql
psql $EDM_DATA -c "\copy (SELECT * FROM dcp_zoningtaxlots.qaqc_mismatch order by version::timestamp) 
    TO STDOUT DELIMITER ',' CSV HEADER;" > output/qaqc_mismatch.csv
