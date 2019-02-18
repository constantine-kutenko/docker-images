#!/bin/bash

set -e

# Define mandatory variables
KAMAILIO_LISTEN_ADDRESS=${KAMAILIO_LISTEN_ADDRESS:-"127.0.0.1"}
KAMAILIO_CONFIG=${KAMAILIO_CONFIG:-"/etc/kamailio/kamailio.cfg"}
KAMAILIO_MODULES=${KAMAILIO_MODULES:-"/usr/lib64/kamailio/modules"}
KAMAILIO_SHARED_MEMORY=${KAMAILIO_SHARED_MEMORY:-256}

KAMAILIO_OPTS="-DD -E -e -a no -l ${KAMAILIO_LISTEN_ADDRESS} -f ${KAMAILIO_CONFIG} -L ${KAMAILIO_MODULES} -m ${KAMAILIO_SHARED_MEMORY}"

# Define optional variables
[[ -z ${KAMAILIO_INTERFACE_CHILD_PROCESSES} ]] || KAMAILIO_OPTS="${KAMAILIO_OPTS} -n ${KAMAILIO_INTERFACE_CHILD_PROCESSES}"
[[ -z ${KAMAILIO_TCP_CHILD_PROCESSES}       ]] || KAMAILIO_OPTS="${KAMAILIO_OPTS} -N ${KAMAILIO_TCP_CHILD_PROCESSES}"
[[ -z ${KAMAILIO_PRIVATE_MEMORY}            ]] || KAMAILIO_OPTS="${KAMAILIO_OPTS} -M ${KAMAILIO_PRIVATE_MEMORY}"
[[ -z ${KAMAILIO_WORKING_DIR}               ]] || KAMAILIO_OPTS="${KAMAILIO_OPTS} -w ${KAMAILIO_WORKING_DIR}"
[[ -z ${KAMAILIO_UID}                       ]] || KAMAILIO_OPTS="${KAMAILIO_OPTS} -u ${KAMAILIO_UID}"
[[ -z ${KAMAILIO_GID}                       ]] || KAMAILIO_OPTS="${KAMAILIO_OPTS} -g ${KAMAILIO_GID}"

function wait_sources()
{
  if [ -z $1 ]; then TIMEOUT=5; else TIMEOUT=$1; fi

  echo -e "Waiting for MySQL database on ${MYSQL_LOCAL_SERVICE_HOST}:${MYSQL_LOCAL_SERVICE_PORT}..."
  until ncat -z ${MYSQL_LOCAL_SERVICE_HOST} ${MYSQL_LOCAL_SERVICE_PORT}; do echo "MySQL database is unreachable. Sleeping for ${TIMEOUT} seconds."; sleep ${TIMEOUT}; done
  echo -e "[ OK ] MySQL database"

  echo -e "Waiting for Redis database on ${REDIS_SERVICE_HOST}:${REDIS_SERVICE_PORT}..."
  until ncat -z ${REDIS_SERVICE_HOST} ${REDIS_SERVICE_PORT}; do echo "Redis database is unreachable. Sleeping for ${TIMEOUT} seconds."; sleep ${TIMEOUT}; done
  echo -e "[ OK ] Redis database"
}

function start_kamailio()
{
  if [[ -n ${CONFD_BACKEND} ]]
    then
      echo -e "\nStarting confd"
      if [ ${CONFD_BACKEND} == 'env' ]
        then confd -onetime -backend ${CONFD_BACKEND}
        else confd -onetime -backend ${CONFD_BACKEND} ${CONFD_BACKEND_OPTS}
      fi
      echo -e "Complete confd"
      wait_sources
      echo -e "\nStarting Kamailio..."
      exec $1 ${KAMAILIO_OPTS}
    else
      if [[ $1 = 'kamailio' ]]
        then
          wait_sources
          echo -e "\nStarting Kamailio..."
          exec $1 ${KAMAILIO_OPTS}
        else exec $@
      fi
  fi
}

case $1 in
  'kamailio')
    start_kamailio $@
  ;;
  *)
    exec $@
  ;;
esac
