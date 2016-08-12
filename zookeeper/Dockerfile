FROM local/geodocker-pbase:latest

# Using locally build base image
MAINTAINER Michael Johns, Pomadchin Grigory, daunnc@gmail.com

# MLJ: Added root
USER root

ENV ZOOKEEPER_VERSION 3.4.6
ENV ZOOKEEPER_HOME /opt/zookeeper
ENV ZOOKEEPER_DATA /data/zookeeper
ENV ZOOKEEPER_CONF_DIR $ZOOKEEPER_HOME/conf
ENV ZOO_LOG4J_PROP WARN,CONSOLE
ENV PATH $PATH:$ZOOKEEPER_HOME/bin

# MLJ: Added `--no-same-owner`
RUN set -x && \
    mkdir -p $ZOOKEEPER_HOME $ZOOKEEPER_DATA && \
    curl -# http://apache-mirror.rbc.ru/pub/apache/zookeeper/zookeeper-${ZOOKEEPER_VERSION}/zookeeper-${ZOOKEEPER_VERSION}.tar.gz | tar -xz --no-same-owner -C ${ZOOKEEPER_HOME} --strip-components=1

# MLJ: Alter for overlay storage driver?
#COPY ./fs /
COPY ./fs/opt /opt
COPY ./fs/sbin /sbin

# MLJ: Added chown
RUN chown -R root:root /opt
RUN chown -R root:root /sbin

WORKDIR "${ZOOKEEPER_HOME}"
# EXPOSE 2181 2888 3888
VOLUME [ "$ZOOKEEPER_DATA" ]

ENTRYPOINT [ "/sbin/entrypoint.sh" ]
CMD [ "zkServer.sh", "start-foreground" ]
