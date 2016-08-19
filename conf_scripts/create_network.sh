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

CLUSTER_NET="${1:-$CLUSTER_NET}"

## VERIFY OPERATION
echo "... USING CLUSTER_NET: '$CLUSTER_NET' (SHOULD NOT BE EMPTY! YOU CAN PROVIDE VALUE AS ARG)"
continueOrQuit ''

## ON CONTINUE
# This script will create the external network used in the cluster.
# By creating separate from docker-compose other containers and services can be included.
docker network create ${CLUSTER_NET}


