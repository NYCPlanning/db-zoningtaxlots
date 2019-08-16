sh 01_setup_ztl.sh

DB_CONTAINER_NAME=ztl
docker start $DB_CONTAINER_NAME
docker inspect -f '{{.State.Running}}' $DB_CONTAINER_NAME
docker exec ztl psql -U postgres -h localhost -c "SELECT 'DATABSE IS UP';"

docker run --rm\
            --network=host\
            -v `pwd`/python:/home/python\
            -w /home/python\
            --env-file .env\
            sptkl/cook:latest python3 dataloading.py