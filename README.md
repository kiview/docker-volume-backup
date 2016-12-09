# docker-volume-backup
Scripts for easy backup and restore of Docker volumes

## Usage

```
./docker_volume_backup.sh {compose_file_path} {project_name} {backup_path} {backup_or_restore} {restore_date}
```

## Examples

Backup

```
./docker_volume_backup.sh /home/kiview/Gitlab/docker-compose.yml gitlab $(pwd)/backup backup
```

Restore

```
./docker_volume_backup.sh /home/kiview/Gitlab/docker-compose.yml gitlab $(pwd)/backup restore 2016-10-19
```
## Docker Container Usage
After building your container, you can use it like this:
```
docker run -v "/home/kiview/Gitlab/:/project" \
    -v "$(pwd)/backup:/backup" \
    -v /var/run/docker.sock:/var/run/docker.sock \
    docker_volume_backup:latest Gitlab /backup backup
```
Note you don't need to provide the path to docker-compose.yml. It is assumed to be mounted under /project/docker-compose.yml. 