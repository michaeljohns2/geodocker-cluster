#! /usr/bin/env bash

# pull in variables from .env
source .env

echo "... you provided the following args and yml file names (don't pass extensions) to view logs '$@' (should not be empty)."
echo "... hints: (1) use 'stack' as an arg for everything. (2) pass --tail=<number> as an arg to just see most recent lines."

tail=""
ymls=()

while [ $# -gt 0 ]; do
  case "$1" in
    --tail=*)
      tail="--tail=${1#*=}"
      echo "... detected arg ${tail}"
      ;;
    *)
      echo "... adding ${1} to yml list"
      ymls=("${ymls[@]}" "${1}")
      ;;
  esac
  shift
done

for var in "${ymls[@]}"
do
    echo "---------------------------------------------------"
    echo "logs for ${var}.yml"
    echo "---------------------------------------------------"
    if [ -n "${tail}" ]
      then
        docker-compose -f "${var}.yml" logs "${tail}"
    else
        docker-compose -f "${var}.yml" logs
    fi
done

