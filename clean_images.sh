#! /usr/bin/env bash

if [ -z ${1+x} ]
 then echo "...prefix is unset"
 exit 1
else 
 echo "...prefix is set to '${1}'"
fi

echo "...removing geoserver image (1 of 7)."
docker rmi ${1}/geodocker-geoserver:latest

echo "...removing accumulo-gis, e.g. geowave, image (2 of 7)."
docker rmi ${1}/geodocker-accumulo-gis:latest

echo "...removing spark image (3 of 7)."
docker rmi ${1}/geodocker-spark:latest

echo "...removing accumulo image (4 of 7)."
docker rmi ${1}/geodocker-accumulo:latest

echo "...removing hadoop image (5 of 7)."
docker rmi ${1}/geodocker-hadoop:latest

echo "...removing zookeeper image (6 of 7)."
docker rmi ${1}/geodocker-zookeeper:latest

echo "...removing base image (7 of 7)."
docker rmi ${1}/geodocker-pbase:latest

echo "...finished."


