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

#name of data container for zookeepre
DATA_CONTAINER_ZOOKEEPER="${1:-$DATA_CONTAINER_ZOOKEEPER}"

#name of data container for hadoop-name
DATA_CONTAINER_HADOOP_NAME="${2:-$DATA_CONTAINER_HADOOP_NAME}"

#name of data container for hadoop-sname
DATA_CONTAINER_HADOOP_SNAME="${3:-$DATA_CONTAINER_HADOOP_SNAME}"

#name of data container for hadoop-data
DATA_CONTAINER_HADOOP="${4:-$DATA_CONTAINER_HADOOP}"

#name of data container for accumulo (master)
DATA_CONTAINER_ACCUMULO="${5:-$DATA_CONTAINER_ACCUMULO}"

#name of data container for spark (master)
DATA_CONTAINER_SPARK="${6:-$DATA_CONTAINER_SPARK}"

#name of data container for geoserver
DATA_CONTAINER_GEOSERVER="${7:-$DATA_CONTAINER_GEOSERVER}"

## VERIFY OPERATION
echo "... USING THE FOLLOWING VARIABLES (SHOULD NOT BE EMPTY! YOU CAN PROVIDE VALUES AS ARGS):"
echo "ARG1 | DATA_CONTAINER_ZOOKEEPER: '$DATA_CONTAINER_ZOOKEEPER'"
echo "ARG2 | DATA_CONTAINER_HADOOP_NAME: '$DATA_CONTAINER_HADOOP_NAME'"
echo "ARG3 | DATA_CONTAINER_HADOOP_SNAME: '$DATA_CONTAINER_HADOOP_SNAME'"
echo "ARG4 | DATA_CONTAINER_HADOOP: '$DATA_CONTAINER_HADOOP'"
echo "ARG5 | DATA_CONTAINER_ACCUMULO: '$DATA_CONTAINER_ACCUMULO'"
echo "ARG6 | DATA_CONTAINER_SPARK: '$DATA_CONTAINER_SPARK'"
echo "ARG7 | DATA_CONTAINER_GEOSERVER: '$DATA_CONTAINER_GEOSERVER'"
continueOrQuit ''

## ON CONTINUE
# this script will remove the data containers for hadoop
# the data containers are used with volumes_from directive in docker-compose-dev.yml

docker rm ${DATA_CONTAINER_ZOOKEEPER}
docker rm ${DATA_CONTAINER_HADOOP_NAME}
docker rm ${DATA_CONTAINER_HADOOP_SNAME}
docker rm ${DATA_CONTAINER_HADOOP}
docker rm ${DATA_CONTAINER_ACCUMULO}
docker rm ${DATA_CONTAINER_SPARK}
docker rm ${DATA_CONTAINER_GEOSERVER}

echo "...expect not to see the data containers"
echo "do you see them in 'docker ps -a'?"
docker ps -a

