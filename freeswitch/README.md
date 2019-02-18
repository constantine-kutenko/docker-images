# FreeSWITCH docker image

## Overview

FreeSWITCH is designed to route and interconnect popular communication protocols using audio, video, text, or any other form
of media. First released in January 2006, FreeSWITCH has grown to become the world’s premier open source soft-switch
platform. This versatile platform is used to power voice, video, and chat communications on devices ranging from single calls on
a Raspberry Pi to large server clusters handling millions of calls. FreeSWITCH powers a number of commercial products
from start-ups to Carriers.

## Requirements

The image to be built and run requires docker - containerization platform. Check [upstream documentation](https://docs.docker.com/install) for how to install docker on your system.

## Building

To build the image run the following command in application root path:

```bash
docker build \
    --pull \
    --tag freeswitch \
    -f docker/Dockerfile .
```

To run the image use:

```bash
docker run \
    --rm \
    --name freeswitch \
    -e "FREESWITCH_CONFIG=freeswitch.xml" \
    -e "APP_ENV=development" \
    -e "CONFD_BACKEND=etcdv3" \
    -e "CONFD_BACKEND_OPTS=-node http://etcd01.example.com:2379 -node http://etcd02.example.com:2379 -node http://etcd03.example.com:2379 --prefix /${APP_ENV}" \
    -it freeswitch \
    freeswitch
```

## Environment variables

| Variable | Default value | Description |
| -------- | ------------- | ----------- |
| FREESWITCH_VERSION  | 1.6           | Defines an actual version of FreeSWITCH to be built and run. |
| FREESWITCH_USER     | freeswitch    | Defines FreeSWITCH process owner.|
| FREESWITCH_GROUP    | freeswitch    | Defines FreeSWITCH process group.|
| FREESWITCH_CONF_DIR | /etc/freeswitch | Defines a directory for FreeSWITCH configuration files. Must be defined along with  FREESWITCH_LOG_DIR and FREESWITCH_DB_DIR. |
| FREESWITCH_CONFIG   | freeswitch.xml | Defines a filename for FreeSWITCH main configuration file. |
| FREESWITCH_LOG_DIR  | /var/log/freeswitch | Defines a directory for logfiles. |
| FREESWITCH_DB_DIR   | /var/lib/freeswitch | Defines a directory for the internal database. |
| FREESWITCH_CONFIG   | /etc/freeswitch/freeswitch.xml | Specifies a path to a configuration file. |
| CONFD_BACKEND       | null          | Defines wheather confd is used to configre FreeSWITCH. |
| CONFD_BACKEND_OPTS  | null          | Defines options for backend to be passed. Is used only if CONFD_BACKEND is not 'env'. |
| APP_ENV             | null          | Defines an environment which the application will be deployed in. |

## License

BSD

## Author Information

Constantine Kutenko <constantine.kutenko@gmail.com> 
