FROM local/geodocker-hadoop:latest

# MLJ: Using locally build base image
MAINTAINER Michael Johns, Pomadchin Grigory, daunnc@gmail.com

ENV SPARK_HOME /opt/spark
ENV SPARK_CONF_DIR $SPARK_HOME/conf
ENV PATH $PATH:$SPARK_HOME/bin:$SPARK_HOME/sbin

RUN set -x && \
    mkdir -p $SPARK_HOME $SPARK_CONF_DIR && \
    curl -# http://d3kbcqa49mib13.cloudfront.net/spark-1.6.1-bin-hadoop2.6.tgz | tar -xz -C ${SPARK_HOME} --strip-components=1

# MLJ: Alter for overlay storage driver
#COPY ./fs /
RUN mkdir -p /opt/spark/conf
COPY ./fs/opt/spark/conf/fairscheduler.xml /opt/spark/conf/
COPY ./fs/opt/spark/conf/log4j.properties /opt/spark/conf/
COPY ./fs/opt/spark/conf/metrics.properties /opt/spark/conf/
COPY ./fs/opt/spark/conf/spark-defaults.conf /opt/spark/conf/
COPY ./fs/opt/spark/conf/spark-env.sh /opt/spark/conf/
COPY ./fs/sbin/entrypoint.sh /sbin/

RUN mkdir -p /data/spark
VOLUME [ "/data/spark" ]

WORKDIR "${SPARK_HOME}"
ENTRYPOINT [ "/sbin/entrypoint.sh" ]

