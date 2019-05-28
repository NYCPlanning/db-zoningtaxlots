#!/bin/bash

####################
### LOADING DATA ### 
####################

docker run -itd --name=zt\
            -v `pwd`:/home/zoningtaxlots_build\
            -w /home/zoningtaxlots_build\
            -p 5434:5432\
            mdillon/postgis

docker run --rm\
            --network=host\
            -v `pwd`/python:/home/python\
            -w /home/python\
            -e "DATAFLOWS_DB_ENGINE=postgresql://postgres@localhost:5434/postgres"\
            sptkl/docker-dataloading:latest python dataloading.py