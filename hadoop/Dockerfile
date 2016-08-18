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

# MLJ: Alter for overlay storage driver
#COPY ./fs /
RUN mkdir -p /opt/hadoop/etc/hadoop
COPY ./fs/opt/hadoop/etc/hadoop/core-site.xml /opt/hadoop/etc/hadoop/
COPY ./fs/opt/hadoop/etc/hadoop/hdfs-site.xml /opt/hadoop/etc/hadoop/
COPY ./fs/sbin/data-node-dev.sh /sbin/
COPY ./fs/sbin/entrypoint.sh /sbin/
COPY ./fs/sbin/name-node.sh /sbin/
COPY ./fs/sbin/sname-node-dev.sh /sbin/

#MLJ: Added mkdir
RUN mkdir -p /data/hdfs
VOLUME ["/data/hdfs"]

WORKDIR "${HADOOP_HOME}"
ENTRYPOINT [ "/sbin/entrypoint.sh" ]

