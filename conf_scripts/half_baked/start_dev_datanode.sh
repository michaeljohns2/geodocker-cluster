#! /usr/bin/env bash

# pull in variables from .env in parent dir
source ../../.env

docker run -d -it --network=${CLUSTER_NET} --volumes-from=${DATA_CONTAINER_HADOOP} --name=geodockercluster_geodocker-hadoop-data_1 ${PULL_PREFIX}/geodocker-hadoop /sbin/entrypoint.sh data dev
