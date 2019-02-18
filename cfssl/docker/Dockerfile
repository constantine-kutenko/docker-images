FROM registry.example.com/centos as builder

#
#
#

ARG CFSSL_VERSION=1.3.2
ARG GO_VERSION=1.10.1
ARG GO_ARCH="amd64"

ENV GO_URL="https://dl.google.com/go/go${GO_VERSION}.linux-${GO_ARCH}.tar.gz" \
    GOPATH="/opt/go"

RUN yum -y update && \
    yum install -y --nogpgcheck \
        yum-plugin-ovl \
        git \
        g++ \
        gcc \
        make && \
    curl -sSL ${GO_URL} | tar xz -C /usr/local && \
    export PATH="/usr/local/go/bin:$PATH" && \
    export GOPATH && \
    export PATH="${GOPATH}/bin:${PATH}" && \
    mkdir -p ${GOPATH}/{src/github.com/cloudflare/cfssl,bin} && \
    chmod -R 777 ${GOPATH} && \
    echo -e "\nBuilding CFSSL binaries...\n" && \
    cd ${GOPATH}/src/github.com/cloudflare/cfssl && \
    git clone --depth 1 -b ${CFSSL_VERSION} https://github.com/cloudflare/cfssl.git . && \
    go get ./...

FROM registry.example.com/centos

#
#
#

ENV CFSSL_BIN_DIR="/opt/cfssl" \
    CFSSL_DATA_DIR="/var/lib/cfssl"

COPY --from=builder /opt/go/bin/* ${CFSSL_BIN_DIR}/bin/
COPY ./confd /etc/confd

COPY docker/entrypoint.sh /entrypoint.sh

WORKDIR ${CFSSL_DATA_DIR}

RUN yum install -y openssh-clients git vim-common && yum clean all && \
    chmod +x ${CFSSL_BIN_DIR}/bin/* && \
    ln -sv ${CFSSL_BIN_DIR}/bin/multirootca /usr/local/bin/multirootca && \
    chmod +x /entrypoint.sh

LABEL name="cfssl" \
      description="An CentOS Linux image containing CloudFlare's PKI/TLS toolkit and Certificate Authority Server." \
      os="CentOS Linux" \
      component.name="cfssl" \
      component.cfssl.version="${CFSSL_VERSION}"

EXPOSE 8888/tcp

ENTRYPOINT ["/entrypoint.sh"]
CMD ["multirootca"]
