#! /usr/bin/env bash

# pull in variables from .env
source .env

function continueOrQuit {
  read -r -p "${1} Continue? [y/N] " response
    response=${response,,}    # tolower
    case $response in
      [y][e][s]|[y]) 
        echo "...continuing with operation"
        ;;
      *)
        echo "...aborting operation"
        exit 1
        ;;
    esac
} 

## VERIFY OPERATION
echo "THIS WILL <<<DESTROY/REMOVE>>> CONTAINERS FROM THE FOLLOWING YML FILES (DON'T PASS EXTENSION):"
for var in "$@"
do
    echo "${var}.yml"
done
echo "... hint: use 'stack' as an arg for everything."
echo "... hint: data volumes will be persisted for next launch."
continueOrQuit ''

## ON CONTINUE

for var in "$@"
do
    echo "... removing containers in ${var}.yml"
    docker-compose -f "${var}.yml" down
done
echo " "
echo "...expect to see the containers removed for passed yml filenames."
echo "do you see them in 'docker ps -a'?"
docker ps -a
