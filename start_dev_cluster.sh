#! /usr/bin/env bash

# pull in variables from .env
source .env

echo "...starting core containers, i.e. zookeeper + hadoop."
docker-compose -f core.yml up

for var in "$@"
do
    echo "... creating containers in ${var}.yml"
    docker-compose -f "${var}.yml" up
done

echo "...expect to see the core containers running (and any others passed in)"
echo "do you see them in 'docker ps'?"
docker ps

