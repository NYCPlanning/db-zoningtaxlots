#!/bin/bash
if [ -f .env ]
then
  export $(cat .env | sed 's/#.*//g' | xargs)
fi

DATE=$(date "+%Y/%m/%d")
schema_name='dcp_zoningtaxlots'

curl -d "{
    \"src_engine\":\"${BUILD_ENGINE}\",
    \"dst_engine\": \"${EDM_DATA}\",
    \"src_schema_name\": \"public\",
    \"dst_schema_name\": \"${schema_name}\",
    \"src_version\": \"${schema_name}\",
    \"dst_version\": \"${DATE}\"
    }"\
    -H "Content-Type: application/json"\
    -X POST $GATEWAY/migrate

psql $EDM_DATA -c "DROP VIEW IF EXISTS ${schema_name}.latest"
psql $EDM_DATA -c "CREATE VIEW ${schema_name}.latest AS 
                    (SELECT * FROM ${schema_name}.\"${DATE}\")"
