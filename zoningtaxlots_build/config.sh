#!/bin/bash

function set_env {
  for envfile in $@
  do
    if [ -f $envfile ]
      then
        export $(cat $envfile | sed 's/#.*//g' | xargs)
      fi
  done
}

function urlparse {
    proto="$(echo $1 | grep :// | sed -e's,^\(.*://\).*,\1,g')"
    url=$(echo $1 | sed -e s,$proto,,g)
    userpass="$(echo $url | grep @ | cut -d@ -f1)"
    BUILD_PWD=`echo $userpass | grep : | cut -d: -f2`
    BUILD_USER=`echo $userpass | grep : | cut -d: -f1`
    hostport=$(echo $url | sed -e s,$userpass@,,g | cut -d/ -f1)
    BUILD_HOST="$(echo $hostport | sed -e 's,:.*,,g')"
    BUILD_PORT="$(echo $hostport | sed -e 's,^.*:,:,g' -e 's,.*:\([0-9]*\).*,\1,g' -e 's,[^0-9],,g')"
    BUILD_DB="$(echo $url | grep / | cut -d/ -f2-)"
}

function SHP_export {
  urlparse $BUILD_ENGINE
  mkdir -p $@ &&
    (
      cd $@
      ogr2ogr -progress -f "ESRI Shapefile" $@.shp \
          PG:"host=$BUILD_HOST user=$BUILD_USER port=$BUILD_PORT dbname=$BUILD_DB password=$BUILD_PWD" \
          -nlt MULTIPOLYGON $@
        rm -f $@.zip
        zip $@.zip *
        ls | grep -v $@.zip | xargs rm
      )
}

function Upload {
  mc rm -r --force spaces/edm-publishing/db-zoningtaxlots/$@
  mc cp -r output spaces/edm-publishing/db-zoningtaxlots/$@
}

function get_latest_version {
  name=$1
  latest_version=$(mc cat spaces/edm-recipes/datasets/$1/latest/config.json |  jq -r '.dataset.version')
}

function import {
  name=$1
  get_latest_version $name
  url=" https://nyc3.digitaloceanspaces.com/edm-recipes/datasets/$name/$latest_version/$name.sql"
  curl -O $url
  psql --quiet $BUILD_ENGINE -f $name.sql
  psql $BUILD_ENGINE -c "ALTER TABLE $name ADD COLUMN v text; UPDATE $name SET v = '$latest_version';"
  rm $name.sql
}

# Set Environmental variables
set_env .env version.env

# Parse URL
urlparse $BUILD_ENGINE

# Set Date
DATE=$(date "+%Y/%m/01")
VERSION=$DATE
VERSION_PREV=$(date --date="$(date "+%Y/%m/01") - 1 month" "+%Y/%m/01")