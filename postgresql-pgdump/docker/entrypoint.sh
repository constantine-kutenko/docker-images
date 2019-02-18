#!/bin/sh

# Define mandatory variables for minio
if [[ -z "${PGDUMP_BACKUP_SERVER_ADDRESS}"     ]]; then echo "An address for a remote backup server must be defined explicitly."; exit 1; fi
if [[ -z "${PGDUMP_BACKUP_SERVER_ACCESS_KEY}"  ]]; then echo "An access key to a remote backup server must be defined explicitly."; exit 1; fi
if [[ -z "${PGDUMP_BACKUP_SERVER_SECRET_KEY}"  ]]; then echo "A secret key for a remote backup server must be defined explicitly."; exit 1; fi
if [[ -z "${PGDUMP_BACKUP_SERVER_BUCKET_NAME}" ]]; then echo "A name of bucket must be defined explicitly."; exit 1; fi
if [[ -z "${PGDUMP_DATABASE_NAME}"             ]]; then echo "A name of database must be defined explicitly."; exit 1; fi
if [[ -z "${PGDUMP_DATABASE_USER}"             ]]; then echo "A username for database must be defined explicitly."; exit 1; fi
if [[ -z "${PGDUMP_DATABASE_PASSWORD}"         ]]; then echo "A password for database must be defined explicitly."; exit 1; fi

# Define mandatory variables for pg_dump
if [[ -z "${POSTGRESQL_SERVICE_HOST}" ]]; then echo "An IP address for a PostgreSQL server must be defined explicitly."; exit 1; fi
if [[ -z "${POSTGRESQL_SERVICE_PORT}" ]]; then echo "An TCP port for a PostgreSQL server must be defined explicitly."; exit 1; fi

# Create minio client config file
mc --insecure config host add minio1 https://${PGDUMP_BACKUP_SERVER_ADDRESS} ${PGDUMP_BACKUP_SERVER_ACCESS_KEY} ${PGDUMP_BACKUP_SERVER_SECRET_KEY} S3v4

PGPASSWORD="${PGDUMP_DATABASE_PASSWORD}"
PGDUMP_OPTS="--host=${POSTGRESQL_SERVICE_HOST} --port=${POSTGRESQL_SERVICE_PORT} --dbname=${PGDUMP_DATABASE_NAME} --username=${PGDUMP_DATABASE_USER} --role=${PGDUMP_DATABASE_USER}"

# Define optional variables
[[ -z ${PGDUMP_COMPRESSION_LEVEL} ]] || PGDUMP_OPTS="${PGDUMP_OPTS} --compress=${PGDUMP_COMPRESSION_LEVEL}"
[[ -z ${PGDUMP_OUTPUT_FORMAT}     ]] || PGDUMP_OPTS="${PGDUMP_OPTS} --format=${PGDUMP_OUTPUT_FORMAT}"

if [[ $1 = 'pg_dump' ]]
then
  exec $@ ${PGDUMP_OPTS} --no-password | gzip -c -9 | mc pipe minio1/${PGDUMP_BACKUP_SERVER_BUCKET_NAME}/zabbix_backup-$(date +%Y-%m-%d).gz
else
  exec $@
fi
