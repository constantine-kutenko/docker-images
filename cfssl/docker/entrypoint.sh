#!/bin/bash

#
#
#

set -e

start_cfssl () {

  CFSSL_CONFIG=${CFSSL_CONFIG:-"multirootca-config.ini"}
  CFSSL_PROFILE=${CFSSL_PROFILE:-"default"}
  CFSSL_OPTS="-l ${CFSSL_PROFILE} -roots ${CFSSL_CONFIG}"

  if [[ -z "${CFSSL_AUTH_STRING}" ]]; then
    export CFSSL_AUTH_STRING=$(head -c16 </dev/urandom|xxd -p -u)
    echo -e "\nUse ${CFSSL_AUTH_STRING} to authenticate your clients\n"
  fi

  if [[ -z "${CERT_REPO_URL}" ]]
    then echo "CERT_REPO_URL is not set but required"; exit 1
  fi

  if [[ -n "${CERT_REPO_SSH_KEY}" ]]; then
    echo "${CERT_REPO_SSH_KEY}" > /root/.ssh/id_rsa
  fi

  confd -onetime -backend env

  echo -e "\nDeploying intermedaite certificate and key for ${CERT_REPO_BRANCH} banch...\n"
  mkdir -p /root/.ssh /tmp/intermediate-ca
  chmod 600 /root/.ssh/id_rsa
  ssh-keyscan $(echo ${CERT_REPO_URL} | awk -F'@' '{print $2}' | awk -F':' '{ print $1}') >> /root/.ssh/known_hosts
  git clone --depth 1 -b ${CERT_REPO_BRANCH} ${CERT_REPO_URL} ${CFSSL_DATA_DIR}/ca
  chmod 0600 -R ${CFSSL_DATA_DIR}/ca/*
  echo -e "\nStarting CFSSL Server...\n"
  exec $@ ${CFSSL_OPTS}
}

case $1 in
  'multirootca')
    start_cfssl $@
  ;;
  *)
    exec $@
  ;;
esac
