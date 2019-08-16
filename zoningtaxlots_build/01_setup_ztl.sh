DB_CONTAINER_NAME=ztl
# [ "$(docker ps -a | grep $DB_CONTAINER_NAME)" ]\
#     && docker kill $DB_CONTAINER_NAME\
#     && docker container prune -f

[ ! "$(docker ps -a | grep $DB_CONTAINER_NAME)" ]\
     && docker run -itd --name=$DB_CONTAINER_NAME\
            -v `pwd`:/home/zoningtaxlots_build\
            -w /home/zoningtaxlots_build\
            --shm-size=1g\
            --cpus=2\
            -p 5435:5432\
            mdillon/postgis