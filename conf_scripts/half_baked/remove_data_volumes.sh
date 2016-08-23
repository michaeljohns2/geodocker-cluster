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

################################################################
# MLJ: THIS IS THE CORE SET OF VOLUMES NEEDED FOR PERSISTENCE
################################################################

#name of docker-compose cluster prefix
CLUSTER_PREPEND="${1:-$CLUSTER_PREPEND}"

#name of data for hadoop-name
DATA_HADOOP_NAME="${2:-$DATA_HADOOP_NAME}"

#name of data for hadoop-sname
DATA_HADOOP_SNAME="${3:-$DATA_HADOOP_SNAME}"

#name of data for hadoop-data
DATA_HADOOP="${4:-$DATA_HADOOP}"

## VERIFY OPERATION
echo "... USING THE FOLLOWING VARIABLES (SHOULD NOT BE EMPTY! YOU CAN PROVIDE VALUES AS ARGS):"
echo "ARG1 | CLUSTER_PREPEND: '$CLUSTER_PREPEND'"
echo "ARG2 | DATA_HADOOP_NAME: '$DATA_HADOOP_NAME'"
echo "ARG3 | DATA_HADOOP_SNAME: '$DATA_HADOOP_SNAME'"
echo "ARG4 | DATA_HADOOP: '$DATA_HADOOP'"
continueOrQuit ''

## ON CONTINUE
# this script will remove persisted data volumes

docker volume rm ${CLUSTER_PREPEND}${DATA_HADOOP_NAME}
docker volume rm ${CLUSTER_PREPEND}${DATA_HADOOP_SNAME}
docker volume rm ${CLUSTER_PREPEND}${DATA_HADOOP}

echo "...expect not to see the data volumes"
echo "do you see them in 'docker volume ls'?"
docker volume ls

