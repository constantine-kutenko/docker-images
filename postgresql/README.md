# PostgreSQL 9.6 docker image

## Overview

PostgreSQL 9.6 database engine.

## Requirements

The image to be built and run requires docker - containerization platform. Check upstream documentation for how to install docker on your system.

## Building

To build an image run following command in application root path

```bash
docker build \
    --pull \
    --tag postgresql \
    -f docker/Dockerfile .
```

To run the image use

```bash
docker run \
    --rm \
    -p 5432:5432 \
    --name postgres \
    --volume /srv/fast_storage/pgsql/9.6/data:/var/lib/pgsql/data:rw \
    -itd \
    registry.example.com/postgresql:9.6 \
    postgres
```

## Environment variables

| Variable | Default value | Description |
| -------- | ------------- | ----------- |
| POSTGRESQL_MAJOR      | 9.6 | Specifies the major version of PostgreSQL server. |
| POSTGRESQL_LISTEN_ADDRESS    | 0.0.0.0 | Specifies an IP address PostgreSQL will start on. This variable is mandatory. |
| POSTGRESQL_LISTEN_PORT       | 5432 | Specifies a TCP port to be binded by PostgreSQL. This variable is mandatory. |
| POSTGRESQL_DATA_DIR   | /var/lib/pgsql/data | Specifies a path to PostgreSQL database files. |
| POSTGRESQL_BIN_DIR    | /usr/pgsql-9.6/bin | Specifies a path to PostgreSQL binary files. |
| POSTGRESQL_USER       | postgres | Specifies a PostgreSQL process owner. |
| POSTGRESQL_GROUP      | postgres | Specifies a PostgreSQL process group. |
| CONTAINER_UID       | 410 | Defines an actual UID will be assigned to PostgreSQL user. |
| CONTAINER_GID       | 610 | Defines an actual GID will be assigned to PostgreSQL group. |

## License

BSD

## Author Information

Constantine Kutenko <constantine.kutenko@gmail.com> 
