CFSSL docker image
==================

A doker image containing CloudFlare's PKI/TLS toolkit and Certificate Authority Server. It is ready to go, but for proper
work you still need to provide it CA certificate and key pair. It uses git to download certificate and key during start
up, so take sure you have uploaded your CA to git repository first. Another requirement is authentication string. If you
do not specify authentication string it will be generated automatically and displayed during start up. Use the string to
authenticate your clients. All parameters can be altered using environment variables. See [Environment variables](#environment-variables

Requirements
------------

The image to be built and run requires docker - containerization platform. Check [upstream documentation](https://docs.docker.com/install)
for how to install docker on your system

Building
--------

To build an image run following command in application root path

```bash
docker build --pull --tag cfssl-server -f docker/Dockerfile .
```

To run the image use

```bash
docker run -p 8888:8888 cfssl-server
```

To verify that CFSSL server is up and running a ready to serve connections use the following string keeping in mind that
root CA certificate (i.e. ```ca.pem```) must be imported into the operating system in advance.

```bash
curl -q -d '{"label": "default"}' http://localhost:8888/api/v1/cfssl/info
```

Environment variables
---------------------

Environment variables is the main mechanism of manipulating application settings inside a container. This is achieved using confd - template designer written on GO. During container startup entrypoint invokes confd generating cfssl configuration using environment variables. Check [upstream documentation](https://github.com/kelseyhightower/confd) for
general understanding of confd. Supported environment variables are listed in a table below.

| Variable            | Default value   | Description |
| ------------------- | --------------- | ----------- |
| CFSSL_VERSION       | 1.3.2           | Specifies a version of CFSSL to be compiled and installed |
| GO_VERSION          | 1.10.1          | Specifies a version of Go to be be use to compile CFSSL binaries |
| CFSSL_BIN_DIR       | /opt/cfssl      | Specifies a directory where CFSSL's binaries are going to be installed |
| CFSSL_DATA_DIR      | /var/lib/cfssl  | Specifies a directory where CFSSL's keys and configuration files will be copied |
| CFSSL_PROFILE       | default         | Specifies a profile that contains parameters for certificate that is about to be issued and appropriate authentication token |
| CFSSL_CONFIG        | multirootca-config.ini | Specifies a path to MultirootCA configuration file |
| CFSSL_CA_KEY_SCHEME | file            | Specifies private key access protocol: 'file' or 'rofile' |
| CFSSL_CA_KEY_NAME   | ca-key.pem      | Specifies a full path to a file stored a private key for a root CA certificate. This variable is mandatory. |
| CFSSL_AUTH_STRING   | null            | Specifies an authentication passphrase |
| CERT_REPO_URL       | null            | Specifies a repository URL containing certificate and key pair |
| CERT_REPO_BRANCH    | master          | Specifies a branch to be cloned from repository specified in CERT_REPO_URL |
| CERT_REPO_SSH_KEY   | null            | An RSA private key to clone a repository specified in CERT_REPO_URL |

## License

BSD

## Author Information

Constantine Kutenko <constantine.kutenko@gmail.com> 
