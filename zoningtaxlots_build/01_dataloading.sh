# Create a postgres database container ztl
DB_CONTAINER_NAME=ztl

[ ! "$(docker ps -a | grep $DB_CONTAINER_NAME)" ]\
     && docker run -itd --name=$DB_CONTAINER_NAME\
            -v `pwd`:/home/zoningtaxlots_build\
            -w /home/zoningtaxlots_build\
            --shm-size=1g\
            --cpus=2\
            --env-file .env\
            -p 5435:5432\
            mdillon/postgis

## Wait for database to get ready, this might take 5 seconds of trys
docker start $DB_CONTAINER_NAME
until docker exec $DB_CONTAINER_NAME psql -h localhost -U postgres; do
    echo "Waiting for postgres container..."
    sleep 0.5
done

docker inspect -f '{{.State.Running}}' $DB_CONTAINER_NAME
docker exec ztl psql -U postgres -h localhost -c "SELECT 'DATABSE IS UP';"

## load data into the ztl container
docker run --rm\
            --network=host\
            -v `pwd`/python:/home/python\
            -w /home/python\
            --env-file .env\
            sptkl/cook:latest python3 dataloading.py

## Do a pg_dump for backup
docker exec ztl pg_dump -d postgres -U postgres | gzip > output/zoningtaxlots.gz