# Atlassian Confluence docker image

## Overview

Atlassian Confluence

## Requirements

The image to be built and run requires docker - containerization platform. Check [upstream documentation](https://docs.docker.com/install)
for how to install docker on your system

## Building

To build an image run following command in application root path

```bash
docker build \
    --pull \
    --tag confluence \
    -f docker/Dockerfile .
```

To run the image use

```bash
docker run \
    --rm \
    -p 8090:8090 \
    -p 8091:8091 \
    --name confluence \
    --volume /var/lib/confluence:/var/lib/confluence:rw \
    -e "CONFLUENCE_DATABASE_PASSWORD=password" \
    -e "TOMCAT_PROXY_ENABLED=true" \
    -e "TOMCAT_PROXY_NAME=confluence.example.com" \
    -e "TOMCAT_PROXY_PORT=8090" \
    -e "TOMCAT_PROXY_SCHEME=http" \
    -e "CONFLUENCE_JAVA_XMS=2048m" \
    -e "CONFLUENCE_JAVA_XMX=4096m" \
    -it confluence \
    confluence
```

## Environment variables

Environment variables is the main mechanism of manipulating application settings inside a container. This is achieved 
using confd - template designer written on GO. During container startup entrypoint invokes confd generating confluence 
configuration using environment variables. Check [upstream documentation](https://github.com/kelseyhightower/confd) for
general understanding of confd. Currently the image recognizes following environment variables:

| Variable | Default value | Description |
| -------- | ------------- | ----------- |
| CONFLUENCE_VERSION   | 6.10.1                    | Defines an actual version of confluence to be downloaded. Can be modified only during build |
| CONFLUENCE_BIN       | /opt/atlassian/confluence | Defines a directory where Confluence archive should be extracted. Can be modified only during build |
| CONFLUENCE_DATA      | /var/lib/confluence       | Defines a directory where Confluence stores it's persistent data. You might want to mount a persistent volume to this location to prevent data loss between confluence restarts. Can be modified only during build |
| CONFLUENCE_GROUP     | atlassian                 | Defines confluence process group. Can be modified only during build |
| CONFLUENCE_USER      | confluence                | Defines confluence process owner. Can be modified only during build |
| CONTAINER_UID        | 401                       | Defines an actual UID will be assigned to confluence user. You must apply this UID to your persistent volume using chown. Can be modified only during build |
| CONTAINER_GID        | 601                       | Defines an actual GID will be assigned to confluence group. You must apply this GID to your persistent volume using chown. Can be modified only during build |
| MYSQL_DRIVER_VERSION | 5.1.46                    | Defines an actual version of mysql connector to be downloaded. Can be modified only during a build |
| PGSQL_DRIVER_VERSION | 42.2.2                    | Defines an actual version of PostgreSQL connector to be downloaded. Can be modified only during a build |
| CONFLUENCE_JAVA_XMS  | 1024m                     | Defines a minimum amount of JAVA memory heap size. Can be modified at any time |
| CONFLUENCE_JAVA_XMX  | 2048m                     | Defines a maximum amount of JAVA memory heap size. Can be modified at any time |

## File system

On production environment you must attach a volume to confluence container to prevent data loss. It must be mounted in 
folder defined in ${CONFLUENCE_DATA} variable. You must also take sure, that correct access rights are applied to this 
folder. Due to possible UIDs and GIDs mismatch between host and container, use UID and GID defined in ${CONTAINER_UID}
and ${CONTAINER_GID} and apply them with chown:

```bash
chown -R ${CONTAINER_UID}:${CONTAINER_GID} ${VOLUME_PATH}
```

## License

BSD

## Author Information

Constantine Kutenko <constantine.kutenko@gmail.com> 
