FROM local/geodocker-accumulo:latest

# Using locally build base image
MAINTAINER Michael Johns, Pomadchin Grigory, daunnc@gmail.com

# MLJ: Added root
USER root

RUN /sbin/load-iterators.sh

ENTRYPOINT [ "/sbin/entrypoint.sh" ]
