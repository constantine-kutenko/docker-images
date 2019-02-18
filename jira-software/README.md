## Atlassian Jira docker image

## Overview

Atlassian jira is a well-know issue tracker and project management software.

## Requirements

The image to be built and run requires docker - containerization platform. Check [upstream documentation](https://docs.docker.com/install)
for how to install docker on your system

## Building

To build an image run following command in application root path

```bash
docker build \
    --pull \
    --tag jira \
    -f docker/Dockerfile .
```

To run the image use

```bash
docker run \
    --rm \
    --net=host \
    --name jira \
    --volume /var/lib/jira:/var/lib/jira:rw \
    -e "JIRA_DATABASE_PASSWORD=password" \
    -e "TOMCAT_PROXY_ENABLED=true" \
    -e "TOMCAT_PROXY_NAME=jira.example.com" \
    -e "TOMCAT_PROXY_PORT=8090" \
    -e "TOMCAT_PROXY_SCHEME=http" \
    -e "JIRA_JAVA_XMS=1024m" \
    -e "JIRA_JAVA_XMX=4096m" \
    -it jira \
    jira
```

## Environment variables

Environment variables is the main mechanism of manipulating application settings inside a container. This is achieved 
using confd - template designer written on GO. During container startup entrypoint invokes confd generating jira 
configuration using environment variables. Check [upstream documentation](https://github.com/kelseyhightower/confd) for
general understanding of confd. Currently the image recognizes following environment variables:

| Variable | Default value | Description |
| -------- | ------------- | ----------- |
| JIRA_VERSION         | 7.11.0              | Defines an actual version of Jira to be downloaded. Can be modified only during build |
| JIRA_BIN             | /opt/atlassian/jira | Defines a directory where Jira archive should be extracted. Can be modified only during build |
| JIRA_DATA            | /var/lib/jira       | Defines a directory where Jira stores it's persistent data. You might want to mount a persistent volume to this location to prevent data loss between jira restarts. Can be modified only during build |
| JIRA_GROUP           | atlassian           | Defines jira process group. Can be modified only during build |
| JIRA_USER            | jira                | Defines jira process owner. Can be modified only during build |
| CONTAINER_UID        | 402                 | Defines an actual UID will be assigned to jira user. You must apply this UID to your persistent volume using chown. Can be modified only during build |
| CONTAINER_GID        | 601                 | Defines an actual GID will be assigned to jira group. You must apply this GID to your persistent volume using chown. Can be modified only during build |
| MYSQL_DRIVER_VERSION | 5.1.46              | Defines an actual version of MySQL connector to be downloaded. Can be modified only during a build |
| PGSQL_DRIVER_VERSION | 42.2.2              | Defines an actual version of PostgreSQL connector to be downloaded. Can be modified only during a build |
| JIRA_JAVA_XMS        | 1024m               | Defines a minimum amount of JAVA memory heap size. Can be modified at any time |
| JIRA_JAVA_XMX        | 2048m               | Defines a maximum amount of JAVA memory heap size. Can be modified at any time |

## File system

On production environment you must attach a volume to jira container to prevent data loss. It must be mounted in 
folder defined in ${JIRA_DATA} variable. You must also take sure, that correct access rights are applied to this 
folder. Due to possible UIDs and GIDs mismatch between host and container, use UID and GID defined in ${CONTAINER_UID}
and ${CONTAINER_GID} and apply them with chown:

```bash
chown -R ${CONTAINER_UID}:${CONTAINER_GID} ${VOLUME_PATH}
```

## License

BSD

## Author Information

Constantine Kutenko <constantine.kutenko@gmail.com> 
