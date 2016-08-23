#! /usr/bin/env bash

# pull in variables from .env
source .env

echo "... this will workaround an issue that may present on relaunch where datanode exits because namenode is still initializing, then after namenode is initialized it doesn't see a datanode and then goes into safemode."
echo " "
echo "... for a more generic description (non-docker specific) see https://discuss.zendesk.com/hc/en-us/articles/200933026-HDFS-goes-into-readonly-mode-and-errors-out-with-Name-node-is-in-safe-mode-"
ehco " "
echo "... to address the issue, we will (1) take namenode out of safemode and (2) bring datanode back up."

echo "... (1) taking namenode out of safemode"
docker-compose -f hadoop.yml exec geodocker-hadoop-name hadoop dfsadmin -safemode leave

echo "... (2) bringing exited datanode back up (via no-recreate)"
docker-compose -f hadoop.yml up --no-recreate -d

echo "... run 'docker-compose -f hadoop.yml logs' to track progress." 
