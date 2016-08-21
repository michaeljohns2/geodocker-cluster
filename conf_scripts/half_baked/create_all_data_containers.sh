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

#name of data container for zookeeper
DATA_CONTAINER_ZOOKEEPER="${2:-$DATA_CONTAINER_ZOOKEEPER}"

#name of data container for hadoop-name
DATA_CONTAINER_HADOOP_NAME="${3:-$DATA_CONTAINER_HADOOP_NAME}"

#name of data container for hadoop-sname
DATA_CONTAINER_HADOOP_SNAME="${4:-$DATA_CONTAINER_HADOOP_SNAME}"

#name of data container for hadoop-data
DATA_CONTAINER_HADOOP="${5:-$DATA_CONTAINER_HADOOP}"

#name of data container for accumulo (master)
DATA_CONTAINER_ACCUMULO="${6:-$DATA_CONTAINER_ACCUMULO}"

#name of data container for spark (master)
DATA_CONTAINER_SPARK="${7:-$DATA_CONTAINER_SPARK}"

#name of data container for geoserver
DATA_CONTAINER_GEOSERVER="${8:-$DATA_CONTAINER_GEOSERVER}"

## VERIFY OPERATION
echo "... USING THE FOLLOWING VARIABLES (SHOULD NOT BE EMPTY! YOU CAN PROVIDE VALUES AS ARGS):"
echo "ARG1 | PULL_PREFIX: '$PULL_PREFIX'"
echo "ARG2 | DATA_CONTAINER_ZOOKEEPER: '$DATA_CONTAINER_ZOOKEEPER'"
echo "ARG3 | DATA_CONTAINER_HADOOP_NAME: '$DATA_CONTAINER_HADOOP_NAME'"
echo "ARG4 | DATA_CONTAINER_HADOOP_SNAME: '$DATA_CONTAINER_HADOOP_SNAME'"
echo "ARG5 | DATA_CONTAINER_HADOOP: '$DATA_CONTAINER_HADOOP'"
echo "ARG6 | DATA_CONTAINER_ACCUMULO: '$DATA_CONTAINER_ACCUMULO'"
echo "ARG7 | DATA_CONTAINER_SPARK: '$DATA_CONTAINER_SPARK'"
echo "ARG8 | DATA_CONTAINER_GEOSERVER: '$DATA_CONTAINER_GEOSERVER'"
continueOrQuit ''

## ON CONTINUE
# this script will create the data containers for hadoop (not for running!!!)
# the data containers will be used with volumes_from directive in docker-compose-dev.yml
# remember, network mode is none if using compose, e.g. `network_mode: none`

docker create -it --name ${DATA_CONTAINER_ZOOKEEPER} ${PULL_PREFIX}/geodocker-zookeeper /bin/true
docker create -it --name ${DATA_CONTAINER_HADOOP_NAME} ${PULL_PREFIX}/geodocker-hadoop /bin/true
docker create -it --name ${DATA_CONTAINER_HADOOP_SNAME} ${PULL_PREFIX}/geodocker-hadoop /bin/true
docker create -it --name ${DATA_CONTAINER_HADOOP} ${PULL_PREFIX}/geodocker-hadoop /bin/true
docker create -it --name ${DATA_CONTAINER_ACCUMULO} ${PULL_PREFIX}/geodocker-accumulo-gis /bin/true
docker create -it --name ${DATA_CONTAINER_SPARK} ${PULL_PREFIX}/geodocker-spark /bin/true
docker create -it --name ${DATA_CONTAINER_GEOSERVER} ${PULL_PREFIX}/geodocker-geoserver /bin/true

echo "...expect to see the new data containers 'created' (not running)"
echo "do you see them in 'docker ps -a'?"
docker ps -a

