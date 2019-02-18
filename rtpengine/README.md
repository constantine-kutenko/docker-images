# rtpEngine docker image

## Overview

The Sipwise NGCP rtpengine is a proxy for RTP traffic and other UDP based media traffic. It's meant to be used with the Kamailio SIP proxy and forms a drop-in replacement for any of the other available RTP and media proxies.

## Requirements

The image to be built and run requires docker - containerization platform. Check [upstream documentation](https://docs.docker.com/install)
for how to install docker on your system

## Building

To build the image run the following command in application root path:

```bash
docker build \
    --pull \
    --tag rtpengine \
    -f docker/Dockerfile .
```

To run the image use:

```bash
docker run \
    --name rtpengine \
    --net=host \
    --cap-add=NET_ADMIN \
    -e "RTPENGINE_INTERFACE_INTERNAL=1.1.1.1" \
    -e "RTPENGINE_INTERFACE_EXTERNAL=2.2.2.2" \
    -e "RTPENGINE_LISTEN_NG=true" \
    -e "RTPENGINE_NG_IP=1.1.1.1" \
    -e "RTPENGINE_KERNEL_MODULE=true" \
    -e "RTPENGINE_TABLE_ID=0" \
    -e "SLACK_WEBHOOK_URL=https://hooks.slack.com/services/QWERTY/ABCDFG/ABCDFG" \
    -itd registry.example.com/rtpengine:mr6.1.1.1-centos
```

## Environment variables

| Variable | Default value | Description |
| ---------| ------------- | ----------- |
| RTPENGINE_VERSION       | mr6.1.1.1     | Defines an actual version of rtpengine to be run |
| RTPENGINE_USER          | rtpengine     | Defines rtpengine process owner.|
| RTPENGINE_GROUP         | rtpengine     | Defines rtpengine process group.|
| RTPENFIGNE_MIN_PORT     | 10000         | Define the lowest port to use for RTP|
| RTPENGINE_MAX_PORT      | 20000         | Define the highest port to use for RTP|
| RTPENGINE_LOG_LEVEL     | 7             | Defines a log level which will be sent to syslog. The log levels correspond to the ones found in the syslog(3) man page. The default value is 6, equivalent to LOG_INFO. The highest possible value is 7 (LOG_DEBUG) which will log everything. |
| RTPENGINE_INTERFACE     | 127.0.0.1     | Specifies a local network interface that is used to listen RTP traffic on. |
| RTPENGINE_LISTEN_TCP    | False         | Defines whether TCP port is listened. |
| RTPENGINE_LISTEN_UDP    | False         | Defines whether UDP port is listened. |
| RTPENGINE_LISTEN_NG     | True          | Defines whether NG protocol is used. |
| RTPENGINE_LISTEN_CLI    | False         | Defines whether TCP port is used to listen for CLI. |
| RTPENGINE_TCP_IP        | 127.0.0.1     | Specifies a local network interface that is used to listen TCP traffic. The variable must be explicitly defined if RTPENGINE_LISTEN_TCP is 'true'. |
| RTPENGINE_UDP_IP        | 127.0.0.1     | Specifies a local network interface that is used to listen UDP traffic. The variable must be explicitly defined if RTPENGINE_LISTEN_UDP is 'true'.|
| RTPENGINE_NG_IP         | 127.0.0.1     | Specifies a local network interface that is used to listen UDP traffic for NG protocol. The variable must be explicitly defined if RTPENGINE_LISTEN_NG is 'true'.|
| RTPENGINE_CLI_IP        | 127.0.0.1     | Specifies a local network interface that is used to listen UDP traffic for CLI. The variable must be explicitly defined if RTPENGINE_LISTEN_CLI is 'true'.|
| RTPENGINE_TCP_PORT      | 7720          | Defines a TCP port to listen on. |
| RTPENGINE_UDP_PORT      | 7722          | Defines a UDP port to listen on. |
| RTPENGINE_NG_PORT       | 7724          | Defines a UDP port to listen on (for NG protocol). |
| RTPENGINE_CLI_PORT      | 7726          | Defines a TCP port to listen on (for command line interface). |
| RTPENGINE_KERNEL_MODULE | True          | Defines whether the kernel module will be used. |
| RTPENGINE_TABLE_ID      | null          | Specifies a table ID that will be used to route thaffic. The variable must be explicitly defined if RTPENGINE_KERNEL_MODULE is 'true'. |
| SLACK_WEBHOOK_URL       | null          | Specifies an Slack webhook URL to messages when the kernel module cannot be used by RTPEngine. |

For information about other possible environment variables see <code>entrypoint.sh</code> script.

## License

BSD

## Author Information

Constantine Kutenko <constantine.kutenko@gmail.com> 
