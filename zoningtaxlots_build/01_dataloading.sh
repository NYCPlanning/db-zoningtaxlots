#!/bin/bash

####################
### LOADING DATA ### 
####################
DB_CONTAINER_NAME=zt
[ ! "$(docker ps -a | grep $DB_CONTAINER_NAME)" ] && docker run -itd --name=$DB_CONTAINER_NAME\
            -v `pwd`:/home/zoningtaxlots_build\
            -w /home/zoningtaxlots_build\
            -p 5434:5432\
            mdillon/postgis

docker run --rm\
            --network=host\
            -v `pwd`/python:/home/python\
            -w /home/python\
            -e "DATAFLOWS_DB_ENGINE=postgresql://postgres@localhost:5434/postgres"\
            sptkl/docker-dataloading:latest python3 dataloading.py