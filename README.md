# docker-volume-backup
Scripts for easy backup and restore of Docker volumes

## Usage

```bash
./docker_volume_backup.sh {compose_file_path} {project_name} {backup_path} {backup_or_restore} {restore_date}
# or
./docker_full_backup.sh {compose_file_path} {project_name} {backup_path} {backup_or_restore} {restore_date}
```

## Examples

### docker_volume_backup.sh

Backup

```bash
./docker_volume_backup.sh /home/kiview/Gitlab/docker-compose.yml gitlab $(pwd)/backup backup
```

Restore

```bash
./docker_volume_backup.sh /home/kiview/Gitlab/docker-compose.yml gitlab $(pwd)/backup restore 2016-10-19
```

### docker_full_backup.sh

```bash
MODE=backup # or restore

path=/opt/mydocker/project1/docker-compose.yml
project=project1
BACKUP_DIR=/tmp/mybackups
DATE=xxxx-xx-xx

#export EXCLUDE_CONTAINER=1
#export EXCLUDE_VOLUMES=1

./docker_full_backup.sh $path $project $BACKUP_DIR $MODE $DATE
```

## Docker Container Usage

After building your container,

```bash
docker build -t docker_volume_backup .
# or
./build.sh
```

you can use it like this:

```bash
PROJECT_DIR   # path to directory that contains the docker files, e.g. docker-compose.yml, Dockerfile, ...
PROJECT_NAME  # Name of the docker container, default is the directory name where docker-compose.yml is stored
BACKUP_DIR    # directory where the tar-files are stored / readed
MODE          # backup or restore
DATE          # if MODE=restore than the date who should restore

# $MODE=backup --> $DATE is ignored
docker run                                            \
    -v "$PROJECT_DIR:/project"                        \
    -v "$BACKUP_DIR:/backup"                          \
    -v /var/run/docker.sock:/var/run/docker.sock      \
    docker_volume_backup:latest $PROJECT_NAME /backup $MODE $DATE
```

Note you don't need to provide the path to docker-compose.yml. It is assumed to be mounted under /project/docker-compose.yml. 
