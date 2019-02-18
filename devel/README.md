# A development and tesing docker image

## Overview

A Docker image that contains necessary tools and utilities to test and verify applications working within the Kubernetes cluster.

## Requirements

The image to be built and run requires docker - containerization platform. Check [upstream documentation](https://docs.docker.com/install) for how to install docker on your system.

## Building

To build the image run the following command in application root path:

```bash
docker build \
    --pull \
    --tag devel \
    -f docker/Dockerfile .
```

To run the image use:

```bash
docker run \
    --rm \
    --name devel \
    -it devel \
    /bin/bash
```

## Environment variables

No environment variables specified.

## License

BSD

## Author Information

Constantine Kutenko <constantine.kutenko@gmail.com> 
