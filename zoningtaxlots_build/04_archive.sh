#!/bin/bash
if [ -f .env ]
then
  export $(cat .env | sed 's/#.*//g' | xargs)
fi

DATE=$(date "+%Y/%m/%d")

curl -d "{
    \"src_engine\":\"${BUILD_ENGINE}\",
    \"dst_engine\": \"${EDM_DATA}\",
    \"src_schema_name\": \"public\",
    \"dst_schema_name\": \"dcp_zoningtaxlots\",
    \"src_version\": \"dcp_zoning_taxlot\",
    \"dst_version\": \"${DATE}\"
    }"\
    -H "Content-Type: application/json"\
    -X POST $GATEWAY/migrate

psql $EDM_DATA -c "DROP VIEW IF EXISTS dcp_zoningtaxlots.latest"
psql $EDM_DATA -c "CREATE VIEW dcp_zoningtaxlots.latest AS 
                    (SELECT * FROM dcp_zoningtaxlots.\"${DATE}\")"
