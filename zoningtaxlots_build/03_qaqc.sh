#!/bin/bash

# make sure we are at the top of the git directory
REPOLOC="$(git rev-parse --show-toplevel)"
cd $REPOLOC

# load config
DBNAME=$(cat $REPOLOC/ztl.config.json | jq -r '.DBNAME')
DBUSER=$(cat $REPOLOC/ztl.config.json | jq -r '.DBUSER')

start=$(date +'%T')
echo "QC the zoning tax lot database"
psql -U $DBUSER -d $DBNAME -f $REPOLOC/zoningtaxlots_build/sql/qc_versioncomparisonfields.sql
#psql -U $DBUSER -d $DBNAME -f $REPOLOC/zoningtaxlots_build/sql/qc_versioncomparisonvalues.sql
psql -U $DBUSER -d $DBNAME -f $REPOLOC/zoningtaxlots_build/sql/qc_bblsaddedandremoved.sql
psql -U $DBUSER -d $DBNAME -f $REPOLOC/zoningtaxlots_build/sql/qc_bbldiffs.sql
pgsql2shp -u $DBUSER -f zoningtaxlots_build/output/qc_bbldiffs $DBNAME "SELECT * FROM bbldiffs WHERE geom IS NOT NULL'"
psql -U $DBUSER -d $DBNAME -f $REPOLOC/zoningtaxlots_build/sql/qc_freqencycomparison.sql