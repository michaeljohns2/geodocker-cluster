FROM local/geodocker-accumulo:latest

# MLJ: Using locally build base image
MAINTAINER Michael Johns, Pomadchin Grigory, daunnc@gmail.com

RUN /sbin/load-iterators.sh

ENTRYPOINT [ "/sbin/entrypoint.sh" ]
