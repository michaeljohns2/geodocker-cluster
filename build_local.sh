#! /usr/bin/env bash

echo "...building local base image (1 of 7)"
cd base
docker build -f centos.dockerfile -t local/geodocker-pbase:latest .

echo "...building local zookeeper image (2 of 7)"
cd ../zookeeper
docker build -t local/geodocker-zookeeper:latest .

echo "...building local hadoop image (3 of 7)"
cd ../hadoop
docker build -t local/geodocker-hadoop:latest .

echo "...building local accumulo image (4 of 7)"
cd ../accumulo
docker build -t local/geodocker-accumulo:latest .

echo "...building local spark image (5 of 7)"
cd ../spark
docker build -t local/geodocker-spark:latest .

echo "...building local geowave / geomesa as accumulo-gis image (6 of 7)"
cd ../extras/accumulo-gis
docker build -t local/geodocker-accumulo-gis:latest .

echo "...building local geoserver image (7 of 7)"
cd ../geoserver
docker build -t local/geodocker-geoserver:latest .

cd ../..

