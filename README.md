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
