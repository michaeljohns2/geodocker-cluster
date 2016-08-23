FROM local/geodocker-hadoop:latest

# MLJ: Using locally build base image
MAINTAINER Michael Johns, Pomadchin Grigory, daunnc@gmail.com

ENV ACCUMULO_VERSION 1.7.2
ENV ACCUMULO_HOME /opt/accumulo
ENV ACCUMULO_CONF_DIR $ACCUMULO_HOME/conf
ENV PATH $PATH:$ACCUMULO_HOME/bin

RUN set -x && \
    mkdir -p ${ACCUMULO_HOME} ${ACCUMULO_CONF_DIR} && \
    curl -# http://apache-mirror.rbc.ru/pub/apache/accumulo/${ACCUMULO_VERSION}/accumulo-${ACCUMULO_VERSION}-bin.tar.gz | tar -xz -C ${ACCUMULO_HOME} --strip-components=1 && \
    cp ${ACCUMULO_HOME}/conf/examples/3GB/standalone/* ${ACCUMULO_CONF_DIR}/

WORKDIR "${ACCUMULO_HOME}"

# Build native bindings for accumulo performance

## MLJ: If need to fix issue with daunnc version
#RUN yum clean all
#RUN rm -f /var/lib/rpm/__db.*
#RUN rpm --rebuilddb
#RUN yum -y distro-sync full
#RUN yum makecache
#RUN yum-complete-transaction

RUN yum -y install make gcc-c++

RUN bash -c "bin/build_native_library.sh"

#COPY ./fs /
# MLJ: Alter COPY for overlay storage driver
RUN mkdir -p /opt/accumulo/conf
COPY ./fs/opt/accumulo/conf/accumulo-env.sh /opt/accumulo/conf/
COPY ./fs/opt/accumulo/conf/accumulo-site.xml /opt/accumulo/conf/
COPY ./fs/opt/accumulo/conf/generic_logger.xml /opt/accumulo/conf/
COPY ./fs/opt/accumulo/conf/monitor_logger.xml /opt/accumulo/conf/
COPY ./fs/sbin/await-master-dev.sh /sbin/
COPY ./fs/sbin/entrypoint.sh /sbin/
COPY ./fs/sbin/load-iterators.sh /sbin/
COPY ./fs/sbin/master-node-dev.sh /sbin/

# DOCUMENTATION ONLY
#EXPOSE 50095

ENTRYPOINT [ "/sbin/entrypoint.sh" ]
