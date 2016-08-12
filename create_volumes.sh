#! /usr/bin/env bash

docker volume create --name=geodocker_dev_zookeeper
docker volume create --name=geodocker_dev_hadoop_name
docker volume create --name=geodocker_dev_hadoop_sname
docker volume create --name=geodocker_dev_hadoop_data
docker volume create --name=geodocker_dev_spark

