#!/bin/sh

if [[ $1 = 'rabbitmq-server' ]]
then
  export RABBITMQ_MNESIA_DIR=${RABBITMQ_DATA}
  export RABBITMQ_PID_FILE="${RABBITMQ_BIN}/rabbitmq.pid"
  export RABBITMQ_CONFIG_FILE="${RABBITMQ_CONFIG_DIR}/rabbitmq"
  
  # Set the Erlang cookie
  if [ -n "${RABBITMQ_ERLANG_COOKIE}" ]
  then
    echo  ${RABBITMQ_ERLANG_COOKIE} > ${RABBITMQ_BIN}/.erlang.cookie
    export RABBITMQ_ERLANG_COOKIE=${RABBITMQ_ERLANG_COOKIE}
    export RABBITMQ_SERVER_ADDITIONAL_ERL_ARGS="-setcookie ${RABBITMQ_ERLANG_COOKIE}"
  fi

  rabbitmq-plugins enable ${RABBITMQ_PLUGINS:-"rabbitmq_management rabbitmq_federation rabbitmq_federation_management"} --offline
fi

exec $@
