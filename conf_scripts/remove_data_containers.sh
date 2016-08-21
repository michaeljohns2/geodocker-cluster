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

################################################################
# MLJ: THIS IS THE CORE SET OF CONTAINERS NEEDED FOR PERSISTENCE
################################################################

#name of data container for hadoop-name
DATA_CONTAINER_HADOOP_NAME="${1:-$DATA_CONTAINER_HADOOP_NAME}"

#name of data container for hadoop-sname
DATA_CONTAINER_HADOOP_SNAME="${2:-$DATA_CONTAINER_HADOOP_SNAME}"

#name of data container for hadoop-data
DATA_CONTAINER_HADOOP="${3:-$DATA_CONTAINER_HADOOP}"

## VERIFY OPERATION
echo "... USING THE FOLLOWING VARIABLES (SHOULD NOT BE EMPTY! YOU CAN PROVIDE VALUES AS ARGS):"
echo "ARG1 | DATA_CONTAINER_HADOOP_NAME: '$DATA_CONTAINER_HADOOP_NAME'"
echo "ARG2 | DATA_CONTAINER_HADOOP_SNAME: '$DATA_CONTAINER_HADOOP_SNAME'"
echo "ARG3 | DATA_CONTAINER_HADOOP: '$DATA_CONTAINER_HADOOP'"
continueOrQuit ''

## ON CONTINUE
# this script will remove the data containers for hadoop
# the data containers are used with volumes_from directive in yml files

docker rm ${DATA_CONTAINER_HADOOP_NAME}
docker rm ${DATA_CONTAINER_HADOOP_SNAME}
docker rm ${DATA_CONTAINER_HADOOP}

echo "...expect not to see the data containers"
echo "do you see them in 'docker ps -a'?"
docker ps -a

