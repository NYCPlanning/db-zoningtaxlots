docker run --rm\
            --network=host\
            -v `pwd`:/home/zoningtaxlots_build\
            -w /home/zoningtaxlots_build\
            -e "DATAFLOWS_DB_ENGINE=postgresql://postgres@localhost:5434/postgres"\
            sptkl/docker-dataloading:latest sh 03_qaqc.sh