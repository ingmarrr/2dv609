#!/bin/bash

cd docker

if [[ $1 == "-e" ]]; then
    docker exec -it postgres-sbx /bin/bash
    exit 0
fi

docker build -t postgres-sbx -f postgres.Dockerfile .
docker run -d --name postgres-sbx -p 5432:5432 postgres-sbx
docker start postgres-sbx

if [[ $1 == "-i" ]]; then
    docker exec -it postgres-sbx /bin/bash
fi
