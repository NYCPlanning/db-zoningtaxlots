#!/bin/bash

# make sure we are at the top of the git directory
REPOLOC="$(git rev-parse --show-toplevel)"
cd $REPOLOC

# load config
DBNAME=$(cat $REPOLOC/ztl.config.json | jq -r '.DBNAME')
DBUSER=$(cat $REPOLOC/ztl.config.json | jq -r '.DBUSER')

start=$(date +'%T')
echo "Starting to build zoning tax lot database"
psql -U $DBUSER -d $DBNAME -f $REPOLOC/pluto_build/sql/create.sql
psql -U $DBUSER -d $DBNAME -f $REPOLOC/pluto_build/sql/bbl.sql
psql -U $DBUSER -d $DBNAME -f $REPOLOC/pluto_build/sql/area_zoningdistrict.sql
psql -U $DBUSER -d $DBNAME -f $REPOLOC/pluto_build/sql/area_commercialoverlay.sql
psql -U $DBUSER -d $DBNAME -f $REPOLOC/pluto_build/sql/area_specialdistrict.sql

