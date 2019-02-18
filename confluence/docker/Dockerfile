FROM registry.example.com/oracle-jdk


ARG CONFLUENCE_VERSION=6.10.1
ARG MYSQL_DRIVER_VERSION=5.1.44
ARG PGSQL_DRIVER_VERSION=42.2.2

ENV CONFLUENCE_BIN=/opt/atlassian/confluence \
    CONFLUENCE_DATA=/var/lib/confluence \
    CONFLUENCE_XML_BACKUP_COPY_DIR=/var/atlassian/application-data/confluence/backups \
    CONFLUENCE_USER=confluence \
    CONFLUENCE_GROUP=atlassian \
    CONTAINER_UID=401 \
    CONTAINER_GID=601

COPY ./confd /etc/confd
COPY ./docker/entrypoint.sh /entrypoint.sh

WORKDIR ${CONFLUENCE_BIN}

RUN groupadd -f -g ${CONTAINER_GID} ${CONFLUENCE_GROUP} && \
    useradd \
        -u ${CONTAINER_UID} \
        -g ${CONTAINER_GID} \
        -c "atlassian confluence" \
        -s /usr/bin/nologin \
        -d /home/${CONFLUENCE_USER} \
        -m ${CONFLUENCE_USER} && \
    curl -sL https://product-downloads.atlassian.com/software/confluence/downloads/atlassian-confluence-${CONFLUENCE_VERSION}.tar.gz | tar --strip=1 -xz && \
    curl -sL http://dev.mysql.com/get/Downloads/Connector-J/mysql-connector-java-${MYSQL_DRIVER_VERSION}.tar.gz | tar -C ${CONFLUENCE_BIN}/confluence/WEB-INF/lib --strip=1 -xz --wildcards --no-anchored "mysql-connector-java-${MYSQL_DRIVER_VERSION}-bin.jar" && \
    rm -f ${CONFLUENCE_BIN}/confluence/WEB-INF/lib/postgresql-*.jar && \
    curl -sL https://jdbc.postgresql.org/download/postgresql-${PGSQL_DRIVER_VERSION}.jar -o ${CONFLUENCE_BIN}/confluence/WEB-INF/lib/postgresql-${PGSQL_DRIVER_VERSION}.jar && \
    install --directory --owner=${CONFLUENCE_USER} --group=${CONFLUENCE_GROUP} ${CONFLUENCE_DATA} && \
    mkdir -p ${CONFLUENCE_XML_BACKUP_COPY_DIR} && \
    chown -R ${CONFLUENCE_USER}:${CONFLUENCE_GROUP} ${CONFLUENCE_BIN} ${CONFLUENCE_XML_BACKUP_COPY_DIR} && \
    chmod +x /entrypoint.sh

USER ${CONFLUENCE_USER}:${CONFLUENCE_GROUP}

EXPOSE 8090/tcp 8091/tcp

LABEL name="Atlassian Confluence" \
      description="Confluence is a content collaboration software" \
      component.confluence.version="${CONFLUENCE_VERSION}"

ENTRYPOINT ["/entrypoint.sh"]

CMD ["confluence"]
