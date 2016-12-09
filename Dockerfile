FROM ubuntu:xenial
MAINTAINER Kevin Wittek <kevin.wittek@groovy-coder.com>


RUN apt update && apt -y install apt-transport-https ca-certificates curl
RUN apt-key adv \
               --keyserver hkp://ha.pool.sks-keyservers.net:80 \
               --recv-keys 58118E89F3A912897C070ADBF76221572C52609D
RUN echo "deb https://apt.dockerproject.org/repo ubuntu-xenial main" | tee /etc/apt/sources.list.d/docker.list
RUN apt update && apt -y install docker-engine
RUN curl -L https://github.com/docker/compose/releases/download/1.9.0/docker-compose-`uname -s`-`uname -m` > /usr/local/bin/docker-compose
RUN chmod +x /usr/local/bin/docker-compose

COPY docker_volume_backup.sh /

ENTRYPOINT ["/docker_volume_backup.sh", "/project/docker-compose.yml"]