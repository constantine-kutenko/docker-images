## Jenkins docker image

## Overview

Jenkins is a software build tool.

## Requirements

The image to be built and run requires docker - containerization platform. Check [upstream documentation](https://docs.docker.com/install)
for how to install docker on your system

## Building

To build an image run following command in application root path

```bash
docker build \
    --pull \
    --tag jenkins \
    -f docker/Dockerfile .
```

To run the image use

```bash
docker run \
    --rm \
    --net=host \
    --name jenkins \
    -it jenkins \
    jenkins
```

## Environment variables

No environment variables specified.

## License

BSD

## Author Information

Constantine Kutenko <constantine.kutenko@gmail.com> 
