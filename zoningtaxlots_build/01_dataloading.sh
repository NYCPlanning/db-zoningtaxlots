#!/bin/bash
if [ -f .env ]
then
  export $(cat .env | sed 's/#.*//g' | xargs)
fi

docker run --rm\
            --network=host\
            -v `pwd`/python:/home/python\
            -w /home/python\
            --env-file .env\
            sptkl/cook:latest python3 dataloading.py
            
# schema_names=(
#     'dcp_commercialoverlay'
#     'dcp_limitedheight'
#     'dcp_mih'
#     'dcp_specialpurpose'
#     'dcp_specialpurposesubdistricts'
#     'dcp_zoningtaxlots'
#     'dcp_zoningmapamendments'
#     'dcp_zoningmapindex'
#     'dof_dtm'
#     'dcp_zoningdistricts')

# for schema_name in ${schema_names[*]}
# do
#     curl -d "{
#     \"src_engine\":\"${RECIPE_ENGINE}\",
#     \"dst_engine\": \"${BUILD_ENGINE}\",
#     \"src_schema_name\": \"${schema_name}\",
#     \"dst_schema_name\": \"public\",
#     \"src_version\": \"latest\",
#     \"dst_version\": \"${schema_name}\"
#     }"\
#     -H "Content-Type: application/json"\
#     -X POST $GATEWAY/migrate &
# done

psql $BUILD_ENGINE -c "
  DROP TABLE IF EXISTS source_data_versions;
  CREATE TABLE source_data_versions as
    (SELECT 'dcp_commercialoverlay' as schema_name, v from dcp_commercialoverlay limit 1)
    UNION
    (SELECT 'dcp_limitedheight' as schema_name, v from dcp_limitedheight limit 1)
    UNION
    (SELECT 'dcp_specialpurpose' as schema_name, v from dcp_specialpurpose limit 1)
    UNION
    (SELECT 'dcp_specialpurposesubdistricts' as schema_name, v from dcp_specialpurposesubdistricts limit 1)
    UNION
    (SELECT 'dcp_zoningmapamendments' as schema_name, v from dcp_zoningmapamendments limit 1)
    UNION
    (SELECT 'dof_dtm' as schema_name, v from dof_dtm limit 1)
    UNION
    (SELECT 'dcp_zoningdistricts' as schema_name, v from dcp_zoningdistricts limit 1);
"