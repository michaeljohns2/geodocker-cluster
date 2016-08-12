FROM local/geodocker-hadoop:latest

# Using locally build base image
MAINTAINER Michael Johns, Pomadchin Grigory, daunnc@gmail.com

# MLJ: Added root
USER root

ENV ACCUMULO_VERSION 1.7.2
ENV ACCUMULO_HOME /opt/accumulo
ENV ACCUMULO_CONF_DIR $ACCUMULO_HOME/conf
ENV PATH $PATH:$ACCUMULO_HOME/bin

# MLJ: Added `--no-same-owner`
RUN set -x && \
    mkdir -p ${ACCUMULO_HOME} ${ACCUMULO_CONF_DIR} && \
    curl -# http://apache-mirror.rbc.ru/pub/apache/accumulo/${ACCUMULO_VERSION}/accumulo-${ACCUMULO_VERSION}-bin.tar.gz | tar -xz --no-same-owner -C ${ACCUMULO_HOME} --strip-components=1 && \
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

# MLJ: Alter for overlay storage driver?
#COPY ./fs /
COPY ./fs/opt /opt
COPY ./fs/sbin /sbin

# MLJ: Added chown
RUN chown -R root:root /opt
RUN chown -R root:root /sbin

ENTRYPOINT [ "/sbin/entrypoint.sh" ]
