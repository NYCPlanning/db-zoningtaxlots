#!/bin/bash
docker exec ztl bash -c '
        pg_dump -t dcp_zoning_taxlot --no-owner -U postgres -d postgres | psql $EDM_DATA
        DATE=$(date "+%Y/%m/%d"); 
        psql $EDM_DATA -c "CREATE SCHEMA IF NOT EXISTS dcp_zoningtaxlots;";
        psql $EDM_DATA -c "ALTER TABLE dcp_zoning_taxlot SET SCHEMA dcp_zoningtaxlots;";
        psql $EDM_DATA -c "DROP TABLE IF EXISTS dcp_zoningtaxlots.\"$DATE\";";
        psql $EDM_DATA -c "ALTER TABLE dcp_zoningtaxlots.dcp_zoning_taxlot RENAME TO \"$DATE\";";
    '