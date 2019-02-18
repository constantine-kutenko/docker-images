FROM registry.example.com/centos

ARG POSTGRESQL_MAJOR="9.6"
ARG POSTGRESQL_DATA_DIR="/var/lib/pgsql/data"

ENV POSTGRESQL_MAJOR=${POSTGRESQL_MAJOR} \
    POSTGRESQL_DATA_DIR=${POSTGRESQL_DATA_DIR} \
    POSTGRESQL_BIN_DIR="/usr/pgsql-${POSTGRESQL_MAJOR}/bin" \
    POSTGRESQL_USER="postgres" \
    POSTGRESQL_GROUP="postgres" \
    CONTAINER_UID=410 \
    CONTAINER_GID=610 \
    TZ="UTC"

COPY docker/entrypoint.sh /entrypoint.sh

# Install PostgreSQL Server and Client packages
RUN groupadd -f -g ${CONTAINER_GID} ${POSTGRESQL_GROUP} && \
    useradd -u ${CONTAINER_UID} -g ${CONTAINER_GID} -s /sbin/nologin -M ${POSTGRESQL_USER} && \
    yum update -y && \
    yum install -y --nogpgcheck yum-plugin-ovl && \
    yum install -y http://yum.postgresql.org/9.6/redhat/rhel-7-x86_64/pgdg-redhat96-9.6-3.noarch.rpm && \
    yum install -y postgresql96-server postgresql96 postgresql96-contrib && \
    yum clean all && \
    rm -rf /var/cache/yum/* && \
    mkdir -p /run/postgresql && \
    chmod +x /entrypoint.sh && \
    chown -R ${POSTGRESQL_USER}:${POSTGRESQL_GROUP} /run/postgresql

WORKDIR ${POSTGRESQL_DATA_DIR}/data

LABEL name="postgres" \
    description="PostgreSQL is a powerful, open source object-relational database system." \
    os="CentOS Linux 7" \
    component.name="postgres" \
    component.postgres.version="${POSTGRESQL_MAJOR}"

USER ${POSTGRESQL_USER}:${POSTGRESQL_GROUP}

ENTRYPOINT ["/entrypoint.sh"]

CMD ["postgres"]
