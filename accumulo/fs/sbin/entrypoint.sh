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

  #sed -i.bak "s/{HADOOP_MASTER_ADDRESS}/${HADOOP_MASTER_ADDRESS}/g" ${ACCUMULO_CONF_DIR}/accumulo-site.xml
  sed "s/{HADOOP_MASTER_ADDRESS}/${HADOOP_MASTER_ADDRESS}/g" ${ACCUMULO_CONF_DIR}/accumulo-site.xml > /tmp/accumulo-site.xml
  mv /tmp/accumulo-site.xml ${ACCUMULO_CONF_DIR}
fi

if [[ ! -v ${ACCUMULO_ZOOKEEPERS} ]]; then
  #sed -i.bak "s/{ACCUMULO_ZOOKEEPERS}/${ACCUMULO_ZOOKEEPERS}/g" ${ACCUMULO_CONF_DIR}/accumulo-site.xml
  sed "s/{ACCUMULO_ZOOKEEPERS}/${ACCUMULO_ZOOKEEPERS}/g" ${ACCUMULO_CONF_DIR}/accumulo-site.xml > /tmp/accumulo-site.xml
  mv /tmp/accumulo-site.xml ${ACCUMULO_CONF_DIR}
fi

if [[ ! -v ${ACCUMULO_SECRET} ]]; then
  #sed -i.bak "s/{ACCUMULO_SECRET}/${ACCUMULO_SECRET}/g" ${ACCUMULO_CONF_DIR}/accumulo-site.xml
  sed "s/{ACCUMULO_SECRET}/${ACCUMULO_SECRET}/g" ${ACCUMULO_CONF_DIR}/accumulo-site.xml > /tmp/accumulo-site.xml
  mv /tmp/accumulo-site.xml ${ACCUMULO_CONF_DIR}
fi

if [[ ! -v ${ACCUMULO_PASSWORD} ]]; then
  #sed -i.bak "s/{ACCUMULO_PASSWORD}/${ACCUMULO_PASSWORD}/g" ${ACCUMULO_CONF_DIR}/accumulo-site.xml
  sed "s/{ACCUMULO_PASSWORD}/${ACCUMULO_PASSWORD}/g" ${ACCUMULO_CONF_DIR}/accumulo-site.xml > /tmp/accumulo-site.xml
  mv /tmp/accumulo-site.xml ${ACCUMULO_CONF_DIR}
fi

# If second argument is provided and is "dev", proceed with production setup
if [ -z "$2" ]; then
  env="prod"
else
  if [ $2 = "dev" ]; then
    env="dev"
  else
    env="prod"
  fi
fi

# The first argument determines this container's role in the accumulo cluster
if [ -z "$1" ]; then
  echo "Select the role for this container with the docker cmd 'master', 'monitor', 'gc', 'tracer', or 'tserver'"
  exit 1
else
  if [ $1 = "master" ]; then
    role="master"
  elif [ $1 = "monitor" ]; then
    role="monitor"
  elif [ $1 = "gc" ]; then
    role="gc"
  elif [ $1 = "tracer" ]; then
    role="tracer"
  elif [ $1 = "tserver" ]; then
    role="tserver"
  else
    role="other"
  fi
fi
echo "Running accumulo container in mode: $env with role: $role"

# Run the appropriate startup script (or noop with ':')
if [ $env = "prod" ]; then
  if [ $role = "master" ]; then
    :
  elif [ $role = "monitor" ]; then
    :
  elif [ $role = "gc" ]; then
    :
  elif [ $role = "tracer" ]; then
    :
  elif [ $role = "tserver" ]; then
    :
  fi
elif [ $env = "dev" ]; then
  if [ $role = "master" ]; then
    source master-node-dev.sh
  elif [ $role = "monitor" ]; then
    source await-master-dev.sh
  elif [ $role = "gc" ]; then
    source await-master-dev.sh
  elif [ $role = "tracer" ]; then
    source await-master-dev.sh
  elif [ $role = "tserver" ]; then
    source await-master-dev.sh
  fi
fi

# Start accumulo
if [ $role = "master" ]; then
  accumulo master
elif [ $role = "monitor" ]; then
  accumulo monitor
elif [ $role = "gc" ]; then
  accumulo gc
elif [ $role = "tracer" ]; then
  accumulo tracer
elif [ $role = "tserver" ]; then
  accumulo tserver
fi

if [ $role = "other" ]; then
  exec "$@"
fi
