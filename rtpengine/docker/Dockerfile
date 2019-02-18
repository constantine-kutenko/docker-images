FROM registry.example.com/centos


ARG RTPENGINE_VERSION=mr6.1.1.1
ENV RTPENGINE_USER=rtpengine \
    RTPENGINE_GROUP=rtpengine \
    CONTAINER_UID=408 \
    CONTAINER_GID=608

COPY docker/entrypoint.sh /entrypoint.sh

RUN groupadd -f -g ${CONTAINER_GID} ${RTPENGINE_GROUP} && \
    useradd -u ${CONTAINER_UID} -g ${CONTAINER_GID} -s /sbin/nologin -M ${RTPENGINE_USER} && \
    yum install -y \
        ngcp-rtpengine \
        ngcp-rtpengine-debuginfo \
        ngcp-rtpengine-dkms \
        ngcp-rtpengine-kernel \
        sudo && \
    yum clean all && \
    rm -rf /var/cache/yum/* && \
    echo 'rtpengine ALL=(ALL) NOPASSWD: /usr/bin/bash, /usr/sbin/rtpengine, /usr/sbin/rtpengine-ctl, /usr/sbin/iptables' >> /etc/sudoers && \
    chmod +x /entrypoint.sh

LABEL name="rtpengine" \
      description="rtpengine is a proxy for RTP traffic and other UDP based media traffic." \
      os="CentOS Linux 7" \
      component.name="rtpengine" \
      component.rtpengine.version="${RTPENGINE_VERSION}"

USER ${RTPENGINE_USER}:${RTPENGINE_GROUP}

EXPOSE 10000-20000/udp

ENTRYPOINT ["/entrypoint.sh"]

CMD ["rtpengine"]
