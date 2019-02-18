FROM registry.example.com/alpine


ARG PGDUMP_VERSION="10.4-r0"

COPY docker/entrypoint.sh /entrypoint.sh

# Install packages
RUN set -ex && \
    apk add --no-cache ca-certificates && \
    apk add --no-cache \
        postgresql-client==${PGDUMP_VERSION} \
        openssl \
        gzip && \
    wget --quiet https://dl.minio.io/client/mc/release/linux-amd64/mc -O /bin/mc && \
    chmod +x /bin/mc /entrypoint.sh

LABEL name="postgres-pgdump" \
    description="PostgreSQL pg_dump database backup tool." \
    os="Alpine Linux" \
    component.name="postgres-pgdump" \
    component.postgres.version="${PGDUMP_VERSION}"

ENTRYPOINT ["/entrypoint.sh"]

CMD ["pg_dump"]
