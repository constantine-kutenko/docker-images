#!/bin/bash

set -e

# Define mandatory variables
FREESWITCH_CONF_DIR=${FREESWITCH_CONF_DIR:-"/etc/freeswitch"}
FREESWITCH_CONFIG=${FREESWITCH_CONFIG:-"freeswitch.xml"}
FREESWITCH_LOG_DIR=${FREESWITCH_LOG_DIR:-"/var/log/freeswitch"}
FREESWITCH_DB_DIR=${FREESWITCH_DB_DIR:-"/var/lib/freeswitch"}

FREESWITCH_OPTS="-c -nf -nonat -nosql -nonatmap -nocal -nort -u ${FREESWITCH_USER} -g ${FREESWITCH_GROUP} -conf ${FREESWITCH_CONF_DIR} -cfgname ${FREESWITCH_CONFIG} -log ${FREESWITCH_LOG_DIR} -db ${FREESWITCH_DB_DIR}"

# Define optional variables
[[ -z ${FREESWITCH_BASE_DIR}       ]] || FREESWITCH_OPTS="${FREESWITCH_OPTS} -base ${FREESWITCH_BASE_DIR}"
[[ -z ${FREESWITCH_RUN_DIR}        ]] || FREESWITCH_OPTS="${FREESWITCH_OPTS} -run ${FREESWITCH_RUN_DIR}"
[[ -z ${FREESWITCH_MOD_DIR}        ]] || FREESWITCH_OPTS="${FREESWITCH_OPTS} -mod ${FREESWITCH_MOD_DIR}"
[[ -z ${FREESWITCH_HTDOCS_DIR}     ]] || FREESWITCH_OPTS="${FREESWITCH_OPTS} -htdocs ${FREESWITCH_HTDOCS_DIR}"
[[ -z ${FREESWITCH_SCRIPTS_DIR}    ]] || FREESWITCH_OPTS="${FREESWITCH_OPTS} -scripts ${FREESWITCH_SCRIPTS_DIR}"
[[ -z ${FREESWITCH_TEMP_DIR}       ]] || FREESWITCH_OPTS="${FREESWITCH_OPTS} -temp ${FREESWITCH_TEMP_DIR}"
[[ -z ${FREESWITCH_GRAMMAR_DIR}    ]] || FREESWITCH_OPTS="${FREESWITCH_OPTS} -grammar ${FREESWITCH_GRAMMAR_DIR}"
[[ -z ${FREESWITCH_CERTS_DIR}      ]] || FREESWITCH_OPTS="${FREESWITCH_OPTS} -certs ${FREESWITCH_CERTS_DIR}"
[[ -z ${FREESWITCH_RECORDINGS_DIR} ]] || FREESWITCH_OPTS="${FREESWITCH_OPTS} -recordings ${FREESWITCH_RECORDINGS_DIR}"
[[ -z ${FREESWITCH_STORAGE_DIR}    ]] || FREESWITCH_OPTS="${FREESWITCH_OPTS} -storage ${FREESWITCH_STORAGE_DIR}"
[[ -z ${FREESWITCH_CACHE_DIR}      ]] || FREESWITCH_OPTS="${FREESWITCH_OPTS} -cache ${FREESWITCH_CACHE_DIR}"
[[ -z ${FREESWITCH_SOUNDS_DIR}     ]] || FREESWITCH_OPTS="${FREESWITCH_OPTS} -sounds ${FREESWITCH_SOUNDS_DIR}"

function start_freeswitch()
{
    if [[ -n ${CONFD_BACKEND} ]]
    then
        echo -e "\nStarting confd"
        if [ ${CONFD_BACKEND} == 'env' ]
        then 
            confd -onetime -backend ${CONFD_BACKEND}
        else
            confd -onetime -backend ${CONFD_BACKEND} ${CONFD_BACKEND_OPTS}
        fi
        echo -e "Complete confd"
        echo -e "\nStarting Freeswitch..."
        exec $1 ${FREESWITCH_OPTS}
    else
        if [[ $1 = 'freeswitch' ]]
        then
            echo -e "\nStarting Freeswitch..."
            exec $1 ${FREESWITCH_OPTS}
        else
            exec $@
        fi
    fi
}

case $1 in
  'freeswitch')
    start_freeswitch $@
  ;;
  *)
    exec $@
  ;;
esac
