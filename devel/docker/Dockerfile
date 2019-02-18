FROM registry.example.com/centos:latest

ARG ETCD_VERSION="3.1.20"

COPY docker/entrypoint.sh /entrypoint.sh

RUN yum install -y --disablerepo=example https://dev.mysql.com/get/mysql57-community-release-el7-11.noarch.rpm && \
    yum install -y --disablerepo=example https://download.postgresql.org/pub/repos/yum/10/redhat/rhel-7-x86_64/pgdg-centos10-10-2.noarch.rpm && \
    yum update -y --disablerepo=example && \
    yum install -y --skip-broken --disablerepo=example \
      bind-utils \
      net-tools \
      telnet \
      tcpdump \
      gcc-c++ \
      make \
      nodejs \
      mysql \
      postgresql10 \
      openssh-clients \
      wget \
      git && \
    yum clean all && \
    rm -rf /var/cache/yum/* && \
    npm -g install amqp-tools && \
    wget -q https://github.com/etcd-io/etcd/releases/download/v${ETCD_VERSION}/etcd-v${ETCD_VERSION}-linux-amd64.tar.gz && \
      tar xzf etcd-v${ETCD_VERSION}-linux-amd64.tar.gz && \
      mv etcd-v${ETCD_VERSION}-linux-amd64/etcd* /bin/ && \
      rm -Rf etcd-v${ETCD_VERSION}-linux-amd64* && \
    wget -q https://storage.googleapis.com/google-code-archive-downloads/v2/code.google.com/paping/paping_1.5.5_x86-64_linux.tar.gz && \
      tar -C /usr/bin -xf paping_1.5.5_x86-64_linux.tar.gz && \
      rm -f paping_1.5.5_x86-64_linux.tar.gz && \
    chmod +x /entrypoint.sh

LABEL name="devel" \
      description="A Docker image that contains necessary tools and utilities to test and verify applications working within the Kubernetes cluster." \

ENTRYPOINT ["/entrypoint.sh"]

CMD ["/bin/bash"]
