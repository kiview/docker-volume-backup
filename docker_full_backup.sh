#!/bin/bash

alpine=alpine:3.6
cdir=containers
vdir=volumes
compose_file_path=$1
project_name=${2,,}
backup_path=$3
backup_or_restore=${4:-backup}
date_suffix=${5:-$(date -I)}

set -e

function backup_volume {
  volume_name=$1
  backup_destination=$2

  docker run --rm -v $volume_name:/data -v $backup_destination:/backup $alpine tar -zcvf /backup/$vdir/$volume_name-$date_suffix.tar.gz /data
}

function backup_container {
  container_id=$1
  backup_destination=$2
  fname="$backup_destination/$cdir/$container_id-$date_suffix.tar.gz"

  docker export $container_id | gzip > $fname
}

function restore_volume {
  volume_name=$1
  backup_destination=$2
  date=$date_suffix

  docker run --rm -v $volume_name:/data $alpine find /data -mindepth 1 -delete
  docker run --rm -v $volume_name:/data -v $backup_destination:/backup $alpine tar -xvf /backup/$vdir/$volume_name-$date.tar.gz -C .
}

function restore_container {
  container_id=$1
  backup_destination=$2
  date=$date_suffix
  fname="$backup_destination/$cdir/$container_id-$date_suffix.tar.gz"

  ["$(docker ps -a | grep $container_id)"] && docker rm -f $container_id
  gunzip -c $fname | docker load
}


function main {
  echo "Docker backup script for project: $project_name"
  echo "  mode: $backup_or_restore"
  
  if [ "$backup_or_restore" == "backup" ] ; then
    mkdir -p $backup_path/$cdir
    mkdir -p $backup_path/$vdir
  fi

  echo "  stopping running containers"
  docker-compose -f $compose_file_path -p $project_name stop

  echo "  enter container images"
  #declare -a containers=()
  #readarray -t containers < <(docker container ls --all -f name=$project_name | awk '{if (NR > 1) print $1}')
  #for c in "${containers[@]}"
  #do
  docker ps --all --quiet -f name=$project_name | while read -sr c ; do
    if [ "$backup_or_restore" == "backup" ]
    then
      echo "  perform container backup: $c"
      backup_container $c $backup_path
    fi

    if [ "$backup_or_restore" == "restore" ]
    then
      echo "  restore container from backup: $c"
      restore_container $c $backup_path
    fi
  done

  echo "  mounting volumes and performing backup/restore..."
  declare -a volumes=()
  readarray -t volumes < <(docker volume ls -f name=$project_name | awk '{if (NR > 1) print $2}')

  for v in "${volumes[@]}"
  do
    if [ "$backup_or_restore" == "backup" ]
    then
      echo "  perform volume backup: $v"
      backup_volume $v $backup_path
    fi

    if [ "$backup_or_restore" == "restore" ]
    then
      echo "  restore volume from backup: $v"
      restore_volume $v $backup_path 
    fi
  done

  echo "  restarting containers"
  docker-compose -f $compose_file_path -p $project_name start

  # write date_id to file
  echo "$date_suffix" >> "$backup_path/stored-backups.ids"

  echo "finished"
}

main
