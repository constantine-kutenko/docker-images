#!/bin/bash

set -e

if [[ $1 = 'rtpengine' ]]
  then
    ## Define mandatory variables with default values
    RTPENGINE_INTERFACE_INTERNAL=${RTPENGINE_INTERFACE_INTERNAL:-127.0.0.1}
    RTPENGINE_INTERFACE_INTERNAL="priv/${RTPENGINE_INTERFACE_INTERNAL}"

    RTPENGINE_LISTEN_TCP=${RTPENGINE_LISTEN_TCP:-false}
    RTPENGINE_LISTEN_UDP=${RTPENGINE_LISTEN_UDP:-false}
    RTPENGINE_LISTEN_NG=${RTPENGINE_LISTEN_NG:-true}
    RTPENGINE_LISTEN_CLI=${RTPENGINE_LISTEN_CLI:-false}

    # Define default values
    RTPENGINE_TCP_IP=${RTPENGINE_TCP_IP:-127.0.0.1}
    RTPENGINE_TCP_PORT=${RTPENGINE_TCP_PORT:-7720}
    RTPENGINE_UDP_IP=${RTPENGINE_UDP_IP:-127.0.0.1}
    RTPENGINE_UDP_PORT=${RTPENGINE_UDP_PORT:-7722}
    RTPENGINE_NG_IP=${RTPENGINE_NG_IP:-127.0.0.1}
    RTPENGINE_NG_PORT=${RTPENGINE_NG_PORT:-7724}
    RTPENGINE_CLI_IP=${RTPENGINE_CLI_IP:-127.0.0.1}
    RTPENGINE_CLI_PORT=${RTPENGINE_CLI_PORT:-7726}
    RTPENGINE_PORT_MIN=${RTPENGINE_PORT_MIN:-10000}
    RTPENGINE_PORT_MAX=${RTPENGINE_PORT_MAX:-20000}

    RTPENGINE_TCP=${RTPENGINE_TCP_IP}:${RTPENGINE_TCP_PORT}
    RTPENGINE_UDP=${RTPENGINE_UDP_IP}:${RTPENGINE_UDP_PORT}
    RTPENGINE_NG=${RTPENGINE_NG_IP}:${RTPENGINE_NG_PORT}
    RTPENGINE_CLI=${RTPENGINE_CLI_IP}:${RTPENGINE_CLI_PORT}

    ## Define rest of variables with
    [[ -z ${RTPENGINE_TIMEOUT}           ]] || RTPENGINE_OPTS="${RTPENGINE_OPTS} --timeout=${RTPENGINE_TIMEOUT}"
    [[ -z ${RTPENGINE_SILENT_TIMEOUT}    ]] || RTPENGINE_OPTS="${RTPENGINE_OPTS} --silent-timeout=${RTPENGINE_SILENT_TIMEOUT}"
    [[ -z ${RTPENGINE_PIDFILE}           ]] || RTPENGINE_OPTS="${RTPENGINE_OPTS} --pidfile=${RTPENGINE_PIDFILE}"
    [[ -z ${RTPENGINE_TOS}               ]] || RTPENGINE_OPTS="${RTPENGINE_OPTS} --tos=${RTPENGINE_TOS}"
    [[ -z ${RTPENGINE_PORT_MIN}          ]] || RTPENGINE_OPTS="${RTPENGINE_OPTS} --port-min=${RTPENGINE_PORT_MIN}"
    [[ -z ${RTPENGINE_PORT_MAX}          ]] || RTPENGINE_OPTS="${RTPENGINE_OPTS} --port-max=${RTPENGINE_PORT_MAX}"
    [[ -z ${RTPENGINE_REDIS}             ]] || RTPENGINE_OPTS="${RTPENGINE_OPTS} --redis=${RTPENGINE_REDIS}"
    [[ -z ${RTPENGINE_REDIS_DB}          ]] || RTPENGINE_OPTS="${RTPENGINE_OPTS} --redis-db=${RTPENGINE_REDIS_DB}"
    [[ -z ${RTPENGINE_REDIS_READ}        ]] || RTPENGINE_OPTS="${RTPENGINE_OPTS} --redis-read=${RTPENGINE_REDIS_READ}"
    [[ -z ${RTPENGINE_REDIS_READ_DB}     ]] || RTPENGINE_OPTS="${RTPENGINE_OPTS} --redis-read-db=${RTPENGINE_REDIS_READ_DB}"
    [[ -z ${RTPENGINE_REDIS_WRITE}       ]] || RTPENGINE_OPTS="${RTPENGINE_OPTS} --redis-write=${RTPENGINE_REDIS_WRITE}"
    [[ -z ${RTPENGINE_REDIS_WRITE_DB}    ]] || RTPENGINE_OPTS="${RTPENGINE_OPTS} --redis-write-db=${RTPENGINE_REDIS_WRITE_DB}"
    [[ -z ${RTPENGINE_B2B_URL}           ]] || RTPENGINE_OPTS="${RTPENGINE_OPTS} --b2b-url=${RTPENGINE_B2B_URL}"
    [[ -z ${RTPENGINE_LOG_LEVEL}         ]] || RTPENGINE_OPTS="${RTPENGINE_OPTS} --log-level=${RTPENGINE_LOG_LEVEL}"
    [[ -z ${RTPENGINE_LOG_FACILITY}      ]] || RTPENGINE_OPTS="${RTPENGINE_OPTS} --log-facility=${RTPENGINE_LOG_FACILITY}"
    [[ -z ${RTPENGINE_LOG_FACILITY_CDR}  ]] || RTPENGINE_OPTS="${RTPENGINE_OPTS} --log-facility-cdr=${RTPENGINE_LOG_FACILITY_CDR}"
    [[ -z ${RTPENGINE_LOG_FACILITY_RTCP} ]] || RTPENGINE_OPTS="${RTPENGINE_OPTS} --log-facility-rtcp=${RTPENGINE_LOG_FACILITY_RTCP}"
    [[ -z ${RTPENGINE_NUM_THREADS}       ]] || RTPENGINE_OPTS="${RTPENGINE_OPTS} --num-threads=${RTPENGINE_NUM_THREADS}"
    [[ -z ${RTPENGINE_DELETE_DELAY}      ]] || RTPENGINE_OPTS="${RTPENGINE_OPTS} --delete-delay=${RTPENGINE_DELETE_DELAY}"
    [[ -z ${RTPENGINE_GRAPHITE}          ]] || RTPENGINE_OPTS="${RTPENGINE_OPTS} --graphite=${RTPENGINE_GRAPHITE}"
    [[ -z ${RTPENGINE_GRAPHITE_INTERVAL} ]] || RTPENGINE_OPTS="${RTPENGINE_OPTS} --graphite-interval=${RTPENGINE_GRAPHITE_INTERVAL}"
    [[ -z ${RTPENGINE_GRAPHITE_PREFIX}   ]] || RTPENGINE_OPTS="${RTPENGINE_OPTS} --graphite-prefix=${RTPENGINE_GRAPHITE_PREFIX}"
    [[ -z ${RTPENGINE_MAX_SESSIONS}      ]] || RTPENGINE_OPTS="${RTPENGINE_OPTS} --max-sessions=${RTPENGINE_MAX_SESSIONS}"

    RTPENGINE_OPTS="-E --foreground --interface=${RTPENGINE_INTERFACE_INTERNAL}"

    if [[ -n ${RTPENGINE_INTERFACE_EXTERNAL} ]]
      then 
        RTPENGINE_INTERFACE_EXTERNAL="pub/${RTPENGINE_INTERFACE_EXTERNAL}"
        RTPENGINE_OPTS="${RTPENGINE_OPTS} --interface=${RTPENGINE_INTERFACE_EXTERNAL}"
    fi

    if [[ ${RTPENGINE_LISTEN_TCP} = 'true' ]]
      then RTPENGINE_OPTS="${RTPENGINE_OPTS} --listen-tcp=${RTPENGINE_TCP}"
    fi

    if [[ ${RTPENGINE_LISTEN_UDP} = 'true' ]]
      then RTPENGINE_OPTS="${RTPENGINE_OPTS} --listen-udp=${RTPENGINE_UDP}"
    fi

    if [[ ${RTPENGINE_LISTEN_NG} = 'true' ]]
      then RTPENGINE_OPTS="${RTPENGINE_OPTS} --listen-ng=${RTPENGINE_NG}"
    fi

    if [[ ${RTPENGINE_LISTEN_CLI} = 'true' ]]
      then RTPENGINE_OPTS="${RTPENGINE_OPTS} --listen-cli=${RTPENGINE_CLI}"
    fi

    if [[ "${RTPENGINE_KERNEL_MODULE}" = "true" && -n "${RTPENGINE_TABLE_ID}" ]]
    then
      # Verify the kernel module is loaded and reachable
      if lsmod | grep xt_RTPENGINE >/dev/null
      then
        # Define additional options
        RTPENGINE_OPTS="${RTPENGINE_OPTS} --table=${RTPENGINE_TABLE_ID} --no-fallback"

        # Add iptables rule to forward the incoming packets to xt_RTPENGINE module
        sudo iptables -I INPUT -p udp -j RTPENGINE --id ${RTPENGINE_TABLE_ID}

        echo "Starting rtpengine (using kernel module)..."
        sudo bash -c "exec $@ ${RTPENGINE_OPTS}"
      else
        echo "The kernel module has not been loaded"

        # Since kernel module has not been loaded allow userspace fallback mode
        RTPENGINE_OPTS="${RTPENGINE_OPTS} --table=${RTPENGINE_TABLE_ID}"
        
        # Notify performance decreasing
        if [ -n "${SLACK_WEBHOOK_URL}" ]
        then
          PAYLOAD="{\"title\":\"RTPEngine\", \"text\":\"RTPEngine instance on ${RTPENGINE_INTERFACE_INTERNAL} was not able to address its kernel module and has been started in fallback mode.\", \"color\":\"#ef0000\", \"username\":\"Voice-Infrastructure\"}"
          curl -X POST -H 'Content-type: application/json' --data "${PAYLOAD}" "${SLACK_WEBHOOK_URL}"
        else
          echo "Notification to Slack has not been sent. Please define variable SLACK_WEBHOOK_URL"
        fi
        
        echo "Starting rtpengine (fallback mode)..."
        exec $@ ${RTPENGINE_OPTS}
      fi
    else
      echo "When kernel module is used the table ID must be provided explicitly. See variable environment RTPENGINE_TABLE_ID."
      exit 1
    fi
  else exec $@
fi
