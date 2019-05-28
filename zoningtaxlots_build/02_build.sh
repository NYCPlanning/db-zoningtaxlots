#!/bin/bash
start=$(date +'%T')
echo "Starting to build zoning tax lot database"
psql $DATAFLOWS_DB_ENGINE -f sql/archive.sql
psql $DATAFLOWS_DB_ENGINE -f sql/create.sql
psql $DATAFLOWS_DB_ENGINE -f sql/bbl.sql
psql $DATAFLOWS_DB_ENGINE -f sql/area_zoningdistrict.sql
psql $DATAFLOWS_DB_ENGINE -f sql/area_commercialoverlay.sql
psql $DATAFLOWS_DB_ENGINE -f sql/area_specialdistrict.sql
psql $DATAFLOWS_DB_ENGINE -f sql/area_limitedheight.sql
psql $DATAFLOWS_DB_ENGINE -f sql/area_zoningmap.sql
psql $DATAFLOWS_DB_ENGINE -f sql/parks.sql
psql $DATAFLOWS_DB_ENGINE -f sql/inzonechange.sql
psql $DATAFLOWS_DB_ENGINE -f sql/correct_duplicatevalues.sql
psql $DATAFLOWS_DB_ENGINE -f sql/correct_zoninggaps.sql
psql $DATAFLOWS_DB_ENGINE -f sql/correct_invalid.sql
psql $DATAFLOWS_DB_ENGINE -f sql/export.sql
echo "Build is done!"