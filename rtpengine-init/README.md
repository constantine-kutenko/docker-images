# rtpEngine-init docker image

## Overview

A Docker image for an initial RTPEngine container that loads the kernel module xt_RTPENGINE to a node's kernel.

## Requirements

The image to be built and run requires docker - containerization platform. Check [upstream documentation](https://docs.docker.com/install)
for how to install docker on your system.

An container from this image can only be effectively run within RHEL and/or CentOS environment. Debian based distributives are not supported.

A container from this image can only be effectively run on RHEL and CentOS. Debian-based ditributives are not supported.

## Building

To build the image run the following command in application root path:

```bash
docker build \
    --pull \
    --tag rtpengine-init \
    -f docker/Dockerfile ./
```

To run the image use:

```bash
docker run \
    --rm \
    --net=host \
    --name rtpengine-init \
    --privileged \
    --cap-add=ALL \
    -itd registry.example.com/rtpengine-init:mr6.1.1.1 \
    rtpengine
```

## Environment variables

| Variable | Default value | Description |
| -------- | ------------- | ----------- |
| RTPENGINE_VERSION    | mr6.1.1.1           | Defines an actual version of the rtpengine module to be compiled and loaded |

For information about other possible environment variables see <code>entrypoint.sh</code> script.

## License

BSD

## Author Information

Constantine Kutenko <constantine.kutenko@gmail.com> 
