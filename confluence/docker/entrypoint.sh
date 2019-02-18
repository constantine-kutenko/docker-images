#!/bin/bash

set -e

start_confluence () {

  sed -i -e 's/-Xms\([0-9]\+[kmg]\) -Xmx\([0-9]\+[kmg]\)/-Xms'${CONFLUENCE_JAVA_XMS:-1024m}' -Xmx'${CONFLUENCE_JAVA_XMX:-2048m}'/g' ${CONFLUENCE_BIN}/bin/setenv.sh

  confd -onetime -backend env

  CONFLUENCE_OPTS="-fg"

  echo "Starting Confluence..."
  exec ${CONFLUENCE_BIN}/bin/start-confluence.sh ${CONFLUENCE_OPTS}
}

case $1 in
  'confluence')
    start_confluence $@
  ;;
  *)
    exec $@
  ;;
esac
