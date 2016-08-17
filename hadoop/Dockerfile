FROM local/geodocker-zookeeper:latest

# Using locally build base image
MAINTAINER Michael Johns,Pomadchin Grigory, daunnc@gmail.com

# MLJ: Added root
USER root

ENV HADOOP_VERSION 2.7.2
ENV HADOOP_HOME /opt/hadoop
ENV HADOOP_PREFIX $HADOOP_HOME
ENV HADOOP_CONF_DIR $HADOOP_PREFIX/etc/hadoop
ENV PATH $PATH:$HADOOP_PREFIX/bin:$HADOOP_PREFIX/sbin

# Install native libs for hadoop
RUN yum install -y snappy snappy-devel lzo lzo-devel hadooplzo hadooplzo-native openssl-devel

# MLJ: Added `--no-same-owner`
RUN set -x && \
    mkdir -p $HADOOP_PREFIX && \
    curl -# http://apache-mirror.rbc.ru/pub/apache/hadoop/common/hadoop-${HADOOP_VERSION}/hadoop-${HADOOP_VERSION}.tar.gz | tar -xz --no-same-owner -C ${HADOOP_PREFIX} --strip-components=1

# MLJ: Alter for overlay storage driver?
#COPY ./fs /
COPY ./fs/opt /opt
COPY ./fs/sbin /sbin

# MLJ: Added chown
RUN chown -R root:root /opt
RUN chown -R root:root /sbin

#MLJ: Added mkdir
RUN mkdir -p /data/hdfs

VOLUME ["/data/hdfs"]

WORKDIR "${HADOOP_HOME}"
ENTRYPOINT [ "/sbin/entrypoint.sh" ]

