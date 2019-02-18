FROM registry.example.com/oracle-jdk

ARG JIRA_VERSION=7.12.2
ARG MYSQL_DRIVER_VERSION=5.1.46
ARG PGSQL_DRIVER_VERSION=42.2.2

ENV JIRA_BIN=/opt/atlassian/jira \
    JIRA_DATA=/var/lib/jira \
    JIRA_USER=jira \
    JIRA_GROUP=atlassian \
    CONTAINER_UID=402 \
    CONTAINER_GID=601

COPY ./confd /etc/confd
COPY ./docker/entrypoint.sh /entrypoint.sh

WORKDIR ${JIRA_BIN}

RUN groupadd -f -g ${CONTAINER_GID} ${JIRA_GROUP} && \
    useradd \
        -u ${CONTAINER_UID} \
        -g ${CONTAINER_GID} \
        -c "atlassian jira" \
        -s /usr/bin/nologin \
        -d /home/${JIRA_USER} \
        -m ${JIRA_USER} && \
    curl -sL https://product-downloads.atlassian.com/software/jira/downloads/atlassian-jira-software-${JIRA_VERSION}.tar.gz | tar --strip=1 -xz && \
    curl -sL http://dev.mysql.com/get/Downloads/Connector-J/mysql-connector-java-${MYSQL_DRIVER_VERSION}.tar.gz | tar -C ${JIRA_BIN}/atlassian-jira/WEB-INF/lib --strip=1 -xz --wildcards --no-anchored "mysql-connector-java-${MYSQL_DRIVER_VERSION}-bin.jar" && \
    rm -f ${JIRA_BIN}/atlassian-jira/WEB-INF/lib/postgresql-*.jar && \
    curl -sL https://jdbc.postgresql.org/download/postgresql-${PGSQL_DRIVER_VERSION}.jar -o ${JIRA_BIN}/atlassian-jira/WEB-INF/lib/postgresql-${PGSQL_DRIVER_VERSION}.jar && \
    install --directory --owner=${JIRA_USER} --group=${JIRA_GROUP} ${JIRA_DATA} && \
    chown -R ${JIRA_USER}:${JIRA_GROUP} . && chmod +x /entrypoint.sh

USER ${JIRA_USER}:${JIRA_GROUP}

EXPOSE 8080/tcp

LABEL name="Atlassian JIRA" \
      description="JIRA is an issue and project tracking software" \
      component.jira.version="${JIRA_VERSION}"

ENTRYPOINT ["/entrypoint.sh"]

CMD ["jira"]
