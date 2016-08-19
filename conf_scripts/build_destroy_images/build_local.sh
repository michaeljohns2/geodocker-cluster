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
echo "... YOU CAN ALSO ISSUE THE FOLLOWING COMMAND: 'docker-compose build'"
continueOrQuit ''

## ON CONTINUE
# This is useful for selectively building by temporarily commenting out unrequired rebuilds
# Also good if docker-compose is unavailable

echo "...building local base image (1 of 7)"
docker build -f centos.dockerfile -t ${PULL_PREFIX}/geodocker-pbase:latest ./base

echo "...building local zookeeper image (2 of 7)"
docker build -t ${PULL_PREFIX}/geodocker-zookeeper:latest ./zookeeper

echo "...building local hadoop image (3 of 7)"
docker build -t ${PULL_PREFIX}/geodocker-hadoop:latest ./hadoop

echo "...building local accumulo image (4 of 7)"
docker build -t ${PULL_PREFIX}/geodocker-accumulo:latest ./accumulo

echo "...building local spark image (5 of 7)"
docker build -t ${PULL_PREFIX}/geodocker-spark:latest ./spark

echo "...building local geowave / geomesa as accumulo-gis image (6 of 7)"
docker build -t ${PULL_PREFIX}/geodocker-accumulo-gis:latest ./extras/accumulo-gis

echo "...building local geoserver image (7 of 7)"
docker build -t ${PULL_PREFIX}/geodocker-geoserver:latest ./extras/geoserver

