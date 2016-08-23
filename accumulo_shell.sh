#! /usr/bin/env bash

# pull in variables from .env
source .env

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

#name of accumulo user
ACC_USER="${1:-$ACC_USER}"

#pwd for user
ACC_PWD="${2:-$ACC_PWD}"

## VERIFY OPERATION
echo "... USING THE FOLLOWING VARIABLES (SHOULD NOT BE EMPTY! YOU CAN PROVIDE VALUES AS ARGS):"
echo "ARG1 | ACC_USER: '$ACC_USER'"
echo "ARG2 | ACC_PWD: '$ACC_PWD'"
continueOrQuit ''

## ON CONTINUE

echo "... starting accumulo shell for user ${ACC_USER} (assumes accumulo is running)."
docker-compose -f accumulo.yml exec geodocker-accumulo-tserver accumulo shell -u ${ACC_USER} -p ${ACC_PWD}

