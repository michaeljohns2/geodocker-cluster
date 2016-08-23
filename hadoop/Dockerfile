FROM local/geodocker-zookeeper:latest

# MLJ: Using locally build base image
MAINTAINER Michael Johns,Pomadchin Grigory, daunnc@gmail.com

ENV HADOOP_VERSION 2.7.2
ENV HADOOP_HOME /opt/hadoop
ENV HADOOP_PREFIX $HADOOP_HOME
ENV HADOOP_CONF_DIR $HADOOP_PREFIX/etc/hadoop
ENV PATH $PATH:$HADOOP_PREFIX/bin:$HADOOP_PREFIX/sbin

# Install native libs for hadoop
RUN yum install -y snappy snappy-devel lzo lzo-devel hadooplzo hadooplzo-native openssl-devel

RUN set -x && \
    mkdir -p $HADOOP_PREFIX && \
    curl -# http://apache-mirror.rbc.ru/pub/apache/hadoop/common/hadoop-${HADOOP_VERSION}/hadoop-${HADOOP_VERSION}.tar.gz | tar -xz -C ${HADOOP_PREFIX} --strip-components=1

#COPY ./fs /
# MLJ: Alter for overlay storage driver
RUN mkdir -p /opt/hadoop/etc/hadoop
COPY ./fs/opt/hadoop/etc/hadoop/core-site.xml /opt/hadoop/etc/hadoop/
COPY ./fs/opt/hadoop/etc/hadoop/hdfs-site.xml /opt/hadoop/etc/hadoop/
COPY ./fs/sbin/data-node-dev.sh /sbin/
COPY ./fs/sbin/entrypoint.sh /sbin/
COPY ./fs/sbin/name-node.sh /sbin/
COPY ./fs/sbin/sname-node-dev.sh /sbin/

# MLJ: Added mkdir
RUN mkdir -p /data/hdfs

# DOCUMENTATION ONLY
#VOLUME ["/data/hdfs"]
# from https://github.com/bigdatafoundation/docker-hadoop/blob/master/2.6.0/Dockerfile

# http://docs.hortonworks.com/HDPDocuments/HDP2/HDP-2.3.0/bk_HDP_Reference_Guide/content/reference_chap2.html
# http://www.cloudera.com/content/cloudera/en/documentation/core/latest/topics/cdh_ig_ports_cdh5.html
# http://hadoop.apache.org/docs/current/hadoop-project-dist/hadoop-common/core-default.xml
# http://hadoop.apache.org/docs/current/hadoop-project-dist/hadoop-hdfs/hdfs-default.xml

# HDFS: NameNode (NN):
#	 8020 = fs.defaultFS			(IPC / File system metadata operations)
#						(9000 is also frequently used alternatively)
#	 8022 = dfs.namenode.servicerpc-address	(optional port used by HDFS daemons to avoid sharing RPC port)
#       50070 = dfs.namenode.http-address	(HTTP  / NN Web UI)
#	50470 = dfs.namenode.https-address	(HTTPS / Secure UI)
# HDFS: DataNode (DN):
#	50010 = dfs.datanode.address		(Data transfer)
#	50020 = dfs.datanode.ipc.address	(IPC / metadata operations)
#	50075 = dfs.datanode.http.address	(HTTP  / DN Web UI)
#	50475 = dfs.datanode.https.address	(HTTPS / Secure UI)
# HDFS: Secondary NameNode (SNN)
#	50090 = dfs.secondary.http.address	(HTTP / Checkpoint for NameNode metadata)
#EXPOSE 9000 50070 50010 50020 50075 50090

WORKDIR "${HADOOP_HOME}"
ENTRYPOINT [ "/sbin/entrypoint.sh" ]

