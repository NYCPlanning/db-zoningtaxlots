#!/bin/bash
proto="$(echo $DATAFLOWS_DB_ENGINE | grep :// | sed -e's,^\(.*://\).*,\1,g')"
url=$(echo $DATAFLOWS_DB_ENGINE | sed -e s,$proto,,g)

DBUSER="$(echo $url | grep @ | cut -d@ -f1)"
host_tmp=$(echo $url | sed -e s,$DBUSER@,,g | cut -d/ -f1)
PORT="$(echo $host_tmp | sed -e 's,^.*:,:,g' -e 's,.*:\([0-9]*\).*,\1,g' -e 's,[^0-9],,g')"
HOST=$(echo $host_tmp | grep : | cut -d: -f1)
DBNAME="$(echo $url | grep / | cut -d/ -f2-)"

#outputting ztl db shapefile
pgsql2shp -U $DBUSER -p $PORT -h HOST -f \
    /home/zoningtaxlots_build/output/zoningtaxlot_db $DBNAME \
    'SELECT a.*, b.geom 
    FROM dcp_zoning_taxlot_export a, dof_dtm b 
    WHERE a."BBL"=b.bbl AND b.geom IS NOT NULL;'

start=$(date +'%T')
echo "QC the zoning tax lot database"
psql $DATAFLOWS_DB_ENGINE -f sql/qc_versioncomparisonfields.sql
#psql -U $DBUSER -d $DBNAME -f $REPOLOC/zoningtaxlots_build/sql/qc_versioncomparisonarea.sql
psql $DATAFLOWS_DB_ENGINE -f sql/qc_bblsaddedandremoved.sql
psql $DATAFLOWS_DB_ENGINE -f sql/qc_bbldiffs.sql

pgsql2shp -U $DBUSER -p $PORT -h HOST -f \
    /home/zoningtaxlots_build/output/qc_bbldiffs $DBNAME \
    "SELECT * FROM bbldiffs WHERE geom IS NOT NULL"

psql $DATAFLOWS_DB_ENGINE -f sql/qc_frequencycomparison.sql
psql $DATAFLOWS_DB_ENGINE -f sql/qc_frequencynownullcomparison.sql