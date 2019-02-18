#!/bin/bash

set -e

start_jira () {

  sed -i 's/JVM_MINIMUM_MEMORY=\".*\"/JVM_MINIMUM_MEMORY=\"'${JIRA_JAVA_XMS:-1024m}'\"/g' ${JIRA_BIN}/bin/setenv.sh
  sed -i 's/JVM_MAXIMUM_MEMORY=\".*\"/JVM_MAXIMUM_MEMORY=\"'${JIRA_JAVA_XMX:-2048m}'\"/g' ${JIRA_BIN}/bin/setenv.sh

  confd -onetime -backend env

  JIRA_OPTS="-fg"

  echo "Starting Jira..."
  exec ${JIRA_BIN}/bin/start-jira.sh ${JIRA_OPTS}
}

case $1 in
  'jira')
    start_jira $@
  ;;
  *)
    exec $@
  ;;
esac