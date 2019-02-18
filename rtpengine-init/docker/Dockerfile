FROM registry.example.com/centos

ARG RTPENGINE_VERSION=mr6.1.1.1
ENV RTPENGINE_VERSION=${RTPENGINE_VERSION}

COPY docker/entrypoint.sh /entrypoint.sh

RUN yum install -y --skip-broken \
        ngcp-rtpengine-debuginfo-${RTPENGINE_VERSION} \
        ngcp-rtpengine-dkms-${RTPENGINE_VERSION} \
        ngcp-rtpengine-kernel-${RTPENGINE_VERSION} \
        gcc \
        make \
        iptables-devel \
    yum clean all && \
    rm -rf /var/cache/yum/* && \
    chmod +x /entrypoint.sh

LABEL name="rtpengine-kernel-module" \
      description="rtpengine is a proxy for RTP traffic and other UDP based media traffic." \
      os="CentOS Linux 7" \
      component.name="rtpengine kernel module" \
      component.rtpengine-kernel-module.version="${RTPENGINE_VERSION}"

USER root

ENTRYPOINT ["/entrypoint.sh"]

CMD ["rtpengine"]
