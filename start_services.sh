#! /usr/bin/env bash

# pull in variables from .env
source .env

echo "... you provided the following yml file names (don't pass extensions) to start '$@' (should not be empty)."
echo "... hint: use 'stack' as an arg for everything."
for var in "$@"
do
    echo "... starting containers in ${var}.yml (creates only if needed)"
    docker-compose -f "${var}.yml" up --no-recreate -d
done

echo "...expect to see containers running for passed yml filenames."
echo " "
echo "do you see them in 'docker ps'?"
docker ps
echo " "
echo "... run 'docker-compose -f <yml> logs' to see progress." 
