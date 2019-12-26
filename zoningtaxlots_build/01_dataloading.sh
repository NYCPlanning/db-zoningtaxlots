#!/bin/bash
if [ -f .env ]
then
  export $(cat .env | sed 's/#.*//g' | xargs)
fi

schema_names=(
    'dcp_commercialoverlay'
    'dcp_limitedheight'
    'dcp_mih'
    'dcp_specialpurpose'
    'dcp_specialpurposesubdistricts'
    'dcp_zoningtaxlots'
    'dcp_zoningmapamendments'
    'dcp_zoningmapindex'
    'dof_dtm'
    'dcp_zoningdistricts')

for schema_name in ${schema_names[*]}
do
    curl -d "{
    \"src_engine\":\"${RECIPE_ENGINE}\",
    \"dst_engine\": \"${BUILD_ENGINE}\",
    \"src_schema_name\": \"${schema_name}\",
    \"dst_schema_name\": \"public\",
    \"src_version\": \"latest\",
    \"dst_version\": \"${schema_name}\"
    }"\
    -H "Content-Type: application/json"\
    -X POST $GATEWAY/migrate &
done
