#! /usr/bin/env bash

echo "<<<for root, run as privileged>>>"

if [ -z ${1+x} ]
 then echo "...chown user is unset"
 exit 1
else 
 echo "...chown user is set to '${1}'"
fi

if [ -z ${2+x} ]
 then echo "...chown group is unset"
 exit 1
else 
 echo "...chown group is set to '${2}'"
fi

echo "... chown for zookeeper/fs/*"
chown -R ${1}:${2} zookeeper/fs/*

echo "... chown for hadoop/fs/*"
chown -R ${1}:${2} hadoop/fs/*

echo "... chown for accumulo/fs/*"
chown -R ${1}:${2} accumulo/fs/*

echo "... chown for spark/fs/*"
chown -R ${1}:${2} spark/fs/*

echo "... generating data volume dirs"
mkdir -p data/gt/hdfs data/gt/spark

