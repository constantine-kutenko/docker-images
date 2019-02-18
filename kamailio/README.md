# Kamailio docker image

## Overview

Kamailio (successor of former OpenSER and SER) is an Open Source SIP Server released under GPL, able to handle thousands
of call setups per second. Kamailio can be used to build large platforms for VoIP and realtime communications – presence,
WebRTC, Instant messaging and other applications.  Moreover, it can be easily used for scaling up SIP-to-PSTN gateways,
PBX systems or media servers like Asterisk™, FreeSWITCH™ or SEMS.

## Requirements

The image to be built and run requires docker - containerization platform. Check [upstream documentation](https://docs.docker.com/install)
for how to install docker on your system

## Building

To build the image run the following command in application root path

```bash
docker build \
    --pull \
    --tag kamailio \
    -f docker/Dockerfile .
```

To run the image use

```bash
docker run \
    --rm \
    --name kamailio \
    -e "KAMAILIO_CONFIG=/etc/kamailio/kamailio.cfg" \
    -e "KAMAILIO_MODULES=/usr/lib64/kamailio/modules" \
    -e "CONFD_BACKEND=etcdv3"
    -e "CONFD_BACKEND_OPTS=-node http://etcd01.example.com:2379 --prefix /development"
    -it kamailio \
    kamailio
```

## Environment variables

| Variable | Default value | Description |
| -------- | ------------- | ----------- |
| KAMAILIO_VERSION   | 5.1           | Defines an actual version of kamailio to be built and run. |
| KAMAILIO_USER      | kamailio      | Defines kamailio process owner.|
| KAMAILIO_GROUP     | kamailio      | Defines kamailio process group.|
| CONTAINER_UID      | 409           | Defines an actual UID will be assigned to kamailio user. |
| CONTAINER_GID      | 609           | Defines an actual GID will be assigned to kamailio group. |
| CONFD_BACKEND      | null          | Defines wheather confd is used to configre kamailio. |
| CONFD_BACKEND_OPTS | null          | Defines options for backend to be passed. Is used only if CONFD_BACKEND is not 'env'. |
| KAMAILIO_CONFIG    | /etc/kamailio/kamailio.cfg | Specifies a path to a configuration file. |
| KAMAILIO_MODULES   | /usr/lib64/kamailio/modules | Specifies a path to a direcory with modules. |

## License

BSD

## Author Information

Constantine Kutenko <constantine.kutenko@gmail.com> 
