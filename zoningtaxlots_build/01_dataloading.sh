#!/bin/bash

####################
### LOADING DATA ### 
####################
DB_CONTAINER_NAME=ztl
[ ! "$(docker ps -a | grep $DB_CONTAINER_NAME)" ] && docker run -itd --name=$DB_CONTAINER_NAME\
            -v `pwd`:/home/zoningtaxlots_build\
            -w /home/zoningtaxlots_build\
            -p 5435:5432\
            mdillon/postgis

docker run --rm\
            --network=host\
            -v `pwd`/python:/home/python\
            -w /home/python\
            --env-file .env\
            sptkl/cook:latest python3 dataloading.py