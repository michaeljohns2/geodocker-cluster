#! /usr/bin/env bash

# pull in variables from .env in parent dir
source ../../.env

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

PULL_PREFIX="${1:-$PULL_PREFIX}"

## VERIFY OPERATION
echo "... ARG1 | PULL_PREFIX: '$PULL_PREFIX' (SHOULD NOT BE EMPTY! YOU CAN PROVIDE VALUE AS ARG)"
continueOrQuit ''

echo "...removing geoserver image (1 of 7)."
docker rmi ${PULL_PREFIX}/geodocker-geoserver:latest

echo "...removing accumulo-gis, e.g. geowave, image (2 of 7)."
docker rmi ${PULL_PREFIX}/geodocker-accumulo-gis:latest

echo "...removing spark image (3 of 7)."
docker rmi ${PULL_PREFIX}/geodocker-spark:latest

echo "...removing accumulo image (4 of 7)."
docker rmi ${PULL_PREFIX}/geodocker-accumulo:latest

echo "...removing hadoop image (5 of 7)."
docker rmi ${PULL_PREFIX}/geodocker-hadoop:latest

echo "...removing zookeeper image (6 of 7)."
docker rmi ${PULL_PREFIX}/geodocker-zookeeper:latest

echo "...removing base image (7 of 7)."
docker rmi ${PULL_PREFIX}/geodocker-pbase:latest

echo "...finished."


