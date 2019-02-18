# Pause docker image

## Introduction

A special image that mocks unfinished projects that are deployed in Kubernetes. The image accepts incoming HTTP queries on a arbitrary TCP port and respond with code 200. If TCP port is not defined explicitly, the value 3000 will be used as default.

## Requirements

The image to be built and run requires docker - containerization platform. Check [upstream documentation](https://docs.docker.com/install)
for how to install docker on your system

## Building and running

To build an image run following command in application root path:

```bash
docker build \
    --pull \
        --tag pause \
        -f docker/Dockerfile .
```

To run the image use:

```bash
docker run \
    -e PORT=3000 \
    -p 3000:3000 \
    pause
```

## Environment variables

| Variable | Default value | Description |
| -------- | ------------- | ----------- |
| PORT | 3000 | TCP port for HTTP server |

## License

BSD

## Author Information

Constantine Kutenko <constantine.kutenko@gmail.com> 
