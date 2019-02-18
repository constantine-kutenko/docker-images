# PostgreSQL pg_dump docker image

## Overview

PostgreSQL pg_dump database backup tool. ```pg_dump``` is a utility for backing up a PostgreSQL database. It makes consistent backups even if the database is being used concurrently. ```pg_dump``` does not block other users accessing the database (readers or writers).

## Requirements

The image to be built and run requires docker - containerization platform. Check upstream documentation for how to install docker on your system.

## Building

To build an image run following command in application root path

```bash
docker build \
    --pull \
    --tag postgres-pgdump \
    -f docker/Dockerfile .
```

To run the image use

```bash
docker run \
    --name postgres-pgdump \
    -e PGDUMP_BACKUP_SERVER_ADDRESS="minio.example.com" \
    -e PGDUMP_BACKUP_SERVER_BUCKET_NAME="test" \
    -e PGDUMP_BACKUP_SERVER_ACCESS_KEY="SOMEACCESSKEY" \
    -e PGDUMP_BACKUP_SERVER_SECRET_KEY="SOMESECRETKEY" \
    -e PGDUMP_DATABASE_SERVICE_IP="192.168.101.30" \
    -t postgres-pgdump \
    pg_dump
```

## Environment variables

| Variable            | Default value   | Description |
| ------------------- | --------------- | ----------- |
| PGDUMP_VERSION | 10.4-r0 | Specifies a version of ```pg_dump``` to be installed. |
| PGDUMP_BACKUP_SERVICE_ADDRESS | null | Specifies an address of a remote server to transfer backup to. |
| PGDUMP_BACKUP_SERVER_ACCESS_KEY | null | Specifies an access key for a remote server. |
| PGDUMP_BACKUP_SERVER_SECRET_KEY | null | Specifies a secret key for a remote server. |
| PGDUMP_BACKUP_SERVER_BUCKET_NAME | null | Specifies a name of a bucket on a remote server. |
| PGDUMP_DATABASE_SERVER | null | Specifies an IP address of a PostgreSQL database server to make backup from. |
| PGDUMP_DATABASE_SERVICE_PORT | 5432 | Specifies a port of a PostgreSQL database server. |
| PGDUMP_DATABASE_NAME | zabbix | Specifies a name of database to be backed up. |
| PGDUMP_DATABASE_USER | zabbix | Specifies a username for a database. |
| PGDUMP_DATABASE_PASSWORD | zabbix | Specifies a password for a database. |
| PGDUMP_COMPRESSION_LEVEL | 0 | Specifies a level of compression. Can take values from 0 to 9. |
| PGDUMP_OUTPUT_FORMAT | p | Specifies an output file format. Can tak values c - custom, d - directory, t - tar, p - plain text. |

## License

BSD

## Author Information

Constantine Kutenko <constantine.kutenko@gmail.com> 
