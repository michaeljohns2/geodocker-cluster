# GeoDocker Cluster

Docker containers with prepared environment to run [GeoTrellis](https://github.com/geotrellis/geotrellis), [GeoMesa](https://github.com/locationtech/geomesa), and [GeoWave](https://github.com/ngageoint/geowave).

*Current version (latest)*: **0.2.1**

__MLJ: THIS IS FORK OF THE ORIGINAL [REPOSITORY](https://github.com/geotrellis/geodocker-cluster) FOR VARIOUS CUSTOMIZATIONS TO INCLUDE WORKING WITH OVERLAY STORAGE DRIVER.__

## Environment

* [Hadoop (HDFS + YARN) 2.7.1](https://hadoop.apache.org/)
* [ZooKeeper 3.4.6](https://zookeeper.apache.org/)
* [Accumulo 1.7.1](https://accumulo.apache.org/)
* [Spark 1.6.1 (Scala 2.10)](http://spark.apache.org/)

## Repository short description (index of ReadMe docs)

Images:

* [accumulo 1.7.1](./accumulo) [[dockerhub]](https://hub.docker.com/r/daunnc/geodocker-accumulo/)
* [hadoop 2.7.1](./hadoop) [[dockerhub]](https://hub.docker.com/r/daunnc/geodocker-hadoop/)
* [spark 1.6.1](./spark) [[dockerhub]](https://hub.docker.com/r/daunnc/geodocker-spark/)
* [zookeeper 3.4.6](./zookeeper) [[dockerhub]](https://hub.docker.com/r/daunnc/geodocker-zookeeper/)
* [cassandra](https://hub.docker.com/_/cassandra/)
  * In run scripts used official cassandra image
* [runners](./runners)
  * Contains runner scripts to simplify cluster startup

## Build and publish a multinode cluster

A more detailed description how to run and to build containers can be found in each image directory.

* If you want to use storage overlay and have docker repo configure in yum (__MLJ: added__)
  * ONLY DO THIS IF (1) YOU ARE RUNNING CENTOS 7 (2) YOU UNDERSTAND WHAT IT MEANS AND (3) __YOU ARE WILLING TO HAVE ALL IMAGES DELETED!!!__
  * overlay `./conf_scripts/docker_config/docker_erase_use_overlayfs.sh` __DELETES ALL IMAGES__
  * back to default `./conf_scripts/docker_config/docker_erase_use_default_storage_driver.sh` __DELETES ALL IMAGES__

* Change environment variables for build (__MLJ: added__)
  * `vi .env`

* Build all images
  * `docker-compose build`
  * clean all images with `./conf_scripts/build_destroy_images/clean_images.sh` (__MLJ: added__)

* Create the shared network used in provided yml files -- this is 1x (__MLJ: added__)
  * `./conf_scripts/create_network.sh`
  * tear down with `./conf_scripts/remove_network.sh`

* Create the shared data containers used in provided yml files -- this is 1x (__MLJ: added__)
  * `./conf_scripts/create_data_containers.sh `
  * tear down with `./conf_scripts/remove_data_containers.sh`

* Correct swappiness setting for Accumulo -- this is 1x (__MLJ: added__)
  * `./conf_scripts/accumulo_config/accumulo_swappiness.sh`
  * make permanent by adding 'vm.swappiness=10' to '/etc/sysctl.conf'

* Publish all images (_optional: this is to quay.io -- requires an account_)
  * `./.docker/release -t=latest --publish`

## Run a multinode cluster

__MLJ: HAVE NOT DEPLOYED TO MULTINODE YET!__

Example of starting a multinode cluster on three machines. Node1 (hostname GeoServer1) is a master node, Node2 (hostname GeoServer2) and Node3 (hostname GeoServer3) slave nodes. Zookeeper strats minimum on three nodes.

```bash
## Zookeepers
# Node1
./1-zookeeper.sh -t=latest -zi=1 -zs1=GeoServer1 -zs2=GeoServer2 -zs3=GeoServer3
# Node2
./1-zookeeper.sh -t=latest -zi=2 -zs1=GeoServer1 -zs2=GeoServer2 -zs3=GeoServer3
# Node3
./1-zookeeper.sh -t=latest -zi=3 -zs1=GeoServer1 -zs2=GeoServer2 -zs3=GeoServer3

## Hadoop
# Node1
./1-hadoop-name.sh -t=latest -hma=GeoServer1
./2-hadoop-sname.sh -t=latest -hma=GeoServer1
./3-hadoop-data.sh -t=latest -hma=GeoServer1
# Node2, Node3
./3-hadoop-data.sh -t=latest -hma=GeoServer1

## Accumulo
# Node1
./1-accumulo-init.sh -t=latest -hma=GeoServer1 -az="GeoServer1,GeoServer2,GeoServer3" -as=secret -ap=GisPwd -in=gis
./2-accumulo-master.sh -t=latest -hma=GeoServer1 -az="GeoServer1,GeoServer2,GeoServer3" -as=secret -ap=GisPwd -in=gis
./3-accumulo-tracer.sh -t=latest -hma=GeoServer1 -az="GeoServer1,GeoServer2,GeoServer3" -as=secret -ap=GisPwd -in=gis
./4-accumulo-gc.sh -t=latest -hma=GeoServer1 -az="GeoServer1,GeoServer2,GeoServer3" -as=secret -ap=GisPwd -in=gis
./5-accumulo-monitor.sh -t=latest -hma=GeoServer1 -az="GeoServer1,GeoServer2,GeoServer3" -as=secret -ap=GisPwd -in=gis
# Node2, Node3
./6-accumulo-tserver.sh -t=latest -hma=GeoServer1 -az="GeoServer1,GeoServer2,GeoServer3" -as=secret -ap=GisPwd -in=gis

## Spark
# Node1
./1-spark-master.sh -t=latest -hma=GeoServer1
# Node2, Node3
./2-spark-worker.sh -t=latest -hma=GeoServer1 -sm=GeoServer1

## Cassandra
# Node1
./1-cassandra-master.sh -t=latest -cla=GeoServer1
# Node2
./2-cassandra-slave.sh -t=latest -cla=GeoServer2 -cs=GeoServer1
# Node3
./2-cassandra-slave.sh -t=latest -cla=GeoServer3 -cs=GeoServer1
```

## Run a local multinode cluster

We can simulate a multinode cluster on a single machine using Docker Compose. [stack.yml](./stack.yml) is an example of instrutions to rise a singlenode cluster, adding additional services description for slave nodes allowed to raise any nodes amount (limited by host machine memory).

```bash
# MLJ: changed, command used to be `docker-compose -f docker-compose-dev.yml up`
docker-compose -f stack.yml up 
```

__MLJ: changed__
For more customized control (including the beginnings of persisted containers):

_from terminal1_
```bash
docker-compose -f core.yml up 
```

_from terminal2_
```bash
docker-compose -f accumulo.yml up 
```

_this could be continued for additional services, the benefit being that core services can be separated from those which depend on it_

#### Tear Down
```bash
# e.g. tear down accumulo, keeping core
docker-compose -f accumulo.yml down 
```

#### Stop
```bash
# e.g. stop stack with out removing containers
docker-compose -f stack.yml stop 
```

## License

* Licensed under the Apache License, Version 2.0: http://www.apache.org/licenses/LICENSE-2.0
