FROM alpine:3.6

RUN apk update
RUN apk add docker
RUN apk add py-pip

RUN pip install docker-compose
RUN apk add bash

RUN rm -rf /var/cache/apk/*

COPY docker_volume_backup.sh /

ENTRYPOINT ["/docker_volume_backup.sh", "/project/docker-compose.yml"]
