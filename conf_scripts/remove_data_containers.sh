#! /usr/bin/env bash

# pull in variables from .env in parent dir
source ../.env

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

#name of data container for zookeeper
DATA_CONTAINER_ZOOKEEPER="${1:-$DATA_CONTAINER_ZOOKEEPER}"

#name of data container for hadoop-name
DATA_CONTAINER_HADOOP_NAME="${2:-$DATA_CONTAINER_HADOOP_NAME}"

#name of data container for hadoop-sname
DATA_CONTAINER_HADOOP_SNAME="${3:-$DATA_CONTAINER_HADOOP_SNAME}"

#name of data container for hadoop-data
DATA_CONTAINER_HADOOP="${4:-$DATA_CONTAINER_HADOOP}"

## VERIFY OPERATION
echo "... USING THE FOLLOWING VARIABLES (SHOULD NOT BE EMPTY! YOU CAN PROVIDE VALUES AS ARGS):"
echo "ARG1 | DATA_CONTAINER_ZOOKEEPER: '$DATA_CONTAINER_ZOOKEEPER'"
echo "ARG2 | DATA_CONTAINER_HADOOP_NAME: '$DATA_CONTAINER_HADOOP_NAME'"
echo "ARG3 | DATA_CONTAINER_HADOOP_SNAME: '$DATA_CONTAINER_HADOOP_SNAME'"
echo "ARG4 | DATA_CONTAINER_HADOOP: '$DATA_CONTAINER_HADOOP'"
continueOrQuit ''

## ON CONTINUE
# this script will remove the data containers for hadoop
# the data containers are used with volumes_from directive in docker-compose-dev.yml

docker rm ${DATA_CONTAINER_ZOOKEEPER}
docker rm ${DATA_CONTAINER_HADOOP_NAME}
docker rm ${DATA_CONTAINER_HADOOP_SNAME}
docker rm ${DATA_CONTAINER_HADOOP}

echo "...expect to not see the new data containers"
echo "do you see them in 'docker ps -a'?"
docker ps -a

