#!/bin/bash
if [ -f .env ]
then
  export $(cat .env | sed 's/#.*//g' | xargs)
fi
if [ -f version.env ]
then
  export $(cat version.env | sed 's/#.*//g' | xargs)
fi

pg_dump -t dcp_zoning_taxlot $BUILD_ENGINE | psql $EDM_DATA
DATE=$(date "+%Y/%m/01")
VERSION=$DATE
psql $EDM_DATA -c "CREATE SCHEMA IF NOT EXISTS dcp_zoningtaxlots;";
psql $EDM_DATA -c "ALTER TABLE dcp_zoning_taxlot SET SCHEMA dcp_zoningtaxlots;";
psql $EDM_DATA -c "DROP TABLE IF EXISTS dcp_zoningtaxlots.\"$DATE\";";
psql $EDM_DATA -c "ALTER TABLE dcp_zoningtaxlots.dcp_zoning_taxlot RENAME TO \"$DATE\";";

psql $EDM_DATA -v VERSION=$VERSION -f sql/qaqc/frequency.sql
psql $EDM_DATA -c "\copy (SELECT * FROM dcp_zoningtaxlots.qaqc_frequency) 
    TO STDOUT DELIMITER ',' CSV HEADER;" > output/qaqc_frequency.csv

psql $EDM_DATA -v VERSION=$VERSION -v VERSION_PREV=$VERSION_PREV -f sql/qaqc/bbl.sql
psql $EDM_DATA -c "\copy (SELECT * FROM dcp_zoningtaxlots.qaqc_bbl) 
    TO STDOUT DELIMITER ',' CSV HEADER;" > output/qaqc_bbl.csv