FROM alpine:3.6
MAINTAINER Kevin Wittek <kevin.wittek@groovy-coder.com>

RUN apk update
RUN apk add docker
RUN apk add py-pip
RUN apk add bash
RUN apk add gzip
RUN rm -rf /var/cache/apk/*

RUN pip install docker-compose

COPY docker_volume_backup.sh /
COPY docker_backup_script.sh /
ENTRYPOINT ["/docker_volume_backup.sh", "/project/docker-compose.yml", "/docker_full_backup.sh"]
