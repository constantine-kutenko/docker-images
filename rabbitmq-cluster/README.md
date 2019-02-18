# RabbitMQ Cluster docker image

## Introduction

RabbitMQ federation.

## Requirements

The image to be built and run requires docker - containerization platform. Check [upstream documentation](https://docs.docker.com/install)
for how to install docker on your system

## Building

To build an image run following command in application root path

```bash
docker build \
    --pull \
    --tag rabbitmq-cluster \
    -f docker/Dockerfile .
```

To run the image use

```bash
docker run \
    --rm \
    -p 5672:5672 \
    -p 15672:15672 \
    -p 25672:25672 \
    -p 4369:4369 \
    -p 5671:5671 \
    --volume /var/lib/rabbitmq_docker:/var/lib/rabbitmq:rw \
    --volume /var/lib/rabbitmq_docker:/var/lib:rw \
    -e RABBITMQ_ERLANG_COOKIE=YREGXMTALRNPDTZENEBE \
    -it rabbitmq-cluster \
    rabbitmq-cluster
```

## Environment variables

| Variable | Default value | Description |
| -------- | ------------- | ----------- |
| RABBITMQ_VERSION       | 3.7.7                     | Specifies an actual version of RabbitMQ server to be downloaded. Can be modified only during build. |
| RABBITMQ_BIN           | /opt/rabbitmq             | Specifies a directory where RabbitMQ archive should be extracted. Can be modified only during build. |
| RABBITMQ_DATA          | /var/lib/rabbitmq         | Specifies a directory where RabbitMQ stores it's persistent data. You might want to mount a persistent volume to this location to prevent data loss between RabbitMQ restarts. Can be modified only during build. |
| RABBITMQ_CONFIG_DIR    | /etc/rabbitmq             | Specifies a directory where RabbitMQ's configuration file may be found. |
| RABBITMQ_USER          | rabbitmq                  | Specifies a RabbitMQ process owner. Can be modified only during build. |
| RABBITMQ_GROUP         | rabbitmq                  | Specifies a RabbitMQ process group. Can be modified only during build. |
| CONTAINER_UID          | 407                       | Specifies an actual UID will be assigned to RabbitMQ user. You must apply this UID to your persistent volume using chown. Can be modified only during build. |
| CONTAINER_GID          | 607                       | Specifies an actual GID will be assigned to RabbitMQ group. You must apply this GID to your persistent volume using chown. Can be modified only during build. |
| RABBITMQ_ERLANG_COOKIE | null                      | Specifies a cookieto be used to authenticate to nodes with '''rabbitmqctl''' and to be used between nodes in a cluster. |

## License

BSD

## Author Information

Constantine Kutenko <constantine.kutenko@gmail.com> 
