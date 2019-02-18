FROM registry.example.com/alpine:3.8

ARG RABBITMQ_VERSION="3.7.7"
ENV RABBITMQ_BIN=/opt/rabbitmq \
    RABBITMQ_DATA=/var/lib/rabbitmq \
    RABBITMQ_CONFIG_DIR=/etc/rabbitmq \
    RABBITMQ_USER=rabbitmq \
    RABBITMQ_GROUP=rabbitmq \
    CONTAINER_UID=407 \
    CONTAINER_GID=607

COPY docker/entrypoint.sh /entrypoint.sh

WORKDIR ${RABBITMQ_BIN}

RUN apk add --no-cache erlang procps tar xz \
      erlang-asn1 \
      erlang-hipe \
      erlang-crypto \
      erlang-eldap \
      erlang-inets \
      erlang-mnesia \
      erlang-os-mon \
      erlang-public-key \
      erlang-sasl \
      erlang-ssl \
      erlang-syntax-tools \
      erlang-xmerl && \
    addgroup -g ${CONTAINER_GID} ${RABBITMQ_GROUP} && \
    adduser -u ${CONTAINER_UID} -G ${RABBITMQ_GROUP} -g "message broker" -s /sbin/nologin -h ${RABBITMQ_BIN} -D ${RABBITMQ_USER} && \
    wget -qO- https://dl.bintray.com/rabbitmq/all/rabbitmq-server/${RABBITMQ_VERSION}/rabbitmq-server-generic-unix-${RABBITMQ_VERSION}.tar.xz | tar --strip=1 -xJ && \
    for i in $(find ${RABBITMQ_BIN}/sbin); do ln -sv ${i} /usr/bin/; done && \
    mkdir -p \
        ${RABBITMQ_CONFIG_DIR} \
        ${RABBITMQ_DATA} && \
    touch ${RABBITMQ_BIN}/.erlang.cookie && \
    chmod 0600 ${RABBITMQ_BIN}/.erlang.cookie && \
    chown -R ${RABBITMQ_USER}:${RABBITMQ_GROUP} \
        ${RABBITMQ_BIN} \
        ${RABBITMQ_CONFIG_DIR} \
        ${RABBITMQ_DATA} && \
    install -d -o ${RABBITMQ_USER} -g ${RABBITMQ_GROUP} ${RABBITMQ_DATA} && \
    chmod +x /entrypoint.sh

USER ${RABBITMQ_USER}:${RABBITMQ_GROUP}

EXPOSE 5672/tcp 15672/tcp 4369/tcp 25672/tcp

LABEL name="RabbitMQ" \
      description="RabbitMQ is the most widely deployed open source message broker" \
      os="Alpine 3.7" \
      component.rabbitmq.version="${RABBITMQ_VERSION}"

ENTRYPOINT ["/entrypoint.sh"]

CMD ["rabbitmq-server"]
