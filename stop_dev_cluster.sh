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
echo "THIS WILL <<<REMOVE>>> CONTAINERS FROM THE FOLLOWING YML FILES:"
for var in "$@"
do
    echo "${var}.yml"
done
echo "THEN IT WILL <<<STOP>>> CONTAINERS FROM CORE.YML."
echo "MAKE SURE YOU ARE NOT LEAVING ANY ORPHANS!"
continueOrQuit ''

## ON CONTINUE

for var in "$@"
do
    echo "... removing containers in ${var}.yml"
    docker-compose -f "${var}.yml" down
done

echo "...stopping (not removing) core containers, i.e. zookeeper + hadoop."
docker-compose -f core.yml stop

echo "...expect to see the core containers stopped (and any others that were passed removed)"
echo "do you see them in 'docker ps -a'?"
docker ps -a
