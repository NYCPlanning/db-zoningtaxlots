# Create a postgres database container ztl
DB_CONTAINER_NAME=ztl

[ ! "$(docker ps -a | grep $DB_CONTAINER_NAME)" ]\
     && docker run -itd --name=$DB_CONTAINER_NAME\
            -v `pwd`:/home/zoningtaxlots_build\
            -w /home/zoningtaxlots_build\
            --shm-size=1g\
            --cpus=2\
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

## To load directly from the backup
docker exec ztl gunzip < output/zoningtaxlots.gz | psql -d postgres -U postgres