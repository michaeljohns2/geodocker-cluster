#! /usr/bin/env bash
set -eo pipefail

###
# MLJ: `sed -i.bak` command breaks inside docker container when using overlay storage driver
# Commented out below with workaround.
###

# Run in all cases
if [[ ! -v ${HADOOP_MASTER_ADDRESS} ]]; then
  #sed -i.bak "s/{HADOOP_MASTER_ADDRESS}/${HADOOP_MASTER_ADDRESS}/g" ${HADOOP_CONF_DIR}/core-site.xml
  sed "s/{HADOOP_MASTER_ADDRESS}/${HADOOP_MASTER_ADDRESS}/g" ${HADOOP_CONF_DIR}/core-site.xml > /tmp/core-site.xml
  mv /tmp/core-site.xml ${HADOOP_CONF_DIR}
fi

# Determine whether this container will run as master, worker, or with another command
if [ -z "$1" ]; then
  role="other"
else
  if [ $1 = "master" ]; then
    role="master"
  elif [ $1 = "worker" ]; then
    role="worker"
  else
    role="other"
  fi
fi

echo "Running spark container with role: $role"

# Decide what to run
if [ $role = "master" ]; then
  bash -c "spark-class org.apache.spark.deploy.master.Master --host $(hostname)"
elif [ $role = "worker" ]; then
  bash -c "spark-class org.apache.spark.deploy.worker.Worker --host $(hostname) spark://${SPARK_MASTER}:7077"
elif [ $role = "other" ]; then
  exec "$@"
fi
