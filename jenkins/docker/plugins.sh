#!/bin/bash

bold="\e[1m"
dim="\e[2m"
underline="\e[4m"
blink="\e[5m"
red="\e[31m"
green="\e[32m"
blue="\e[34m"
white="\e[97m"
reset="\e[0m"

PLUGINS_DIR="/var/lib/jenkins/plugins"
PLUGINS_LIST="$HOME/plugins.txt"
PLUGINS_COUNT=0
COUNTER=1

# Stop Jenkins
echo -e "${green}\n>>> Stopping Jenkins instance${reset}"
/etc/init.d/jenkins stop

# Cleanup plugins' directory
echo -e "${green}>>> Cleaning up plugins' directory${reset}"
rm -rf /var/lib/jenkins/plugins/*

PLUGINS_COUNT=$(wc $HOME/plugins.txt | awk '{ print $2 }')
echo -e "${green}>>> Installing minimal set of Jenkins' plugins ($PLUGINS_COUNT):${reset}"

while IFS= read -r JENKINS_PLUGIN_NAME
do
    echo -e "($COUNTER/$PLUGINS_COUNT) ${white}$JENKINS_PLUGIN_NAME${reset}"
    wget \
        –quiet \
        -O /var/lib/jenkins/plugins/${JENKINS_PLUGIN_NAME}.jpi \
        https://updates.jenkins-ci.org/latest/${JENKINS_PLUGIN_NAME}.hpi 2> /dev/null
    COUNTER=$(( $COUNTER + 1 ))
done < $PLUGINS_LIST

exit 0

# Set permittions
chown -R jenkins:jenkins /var/lib/jenkins/plugins/*.*

echo -e "${green}>>> Plugins' installation done!${reset}"

# Start Jenkins
echo -e "${green}>>> Starting Jenkins instance${reset}\n"
/etc/init.d/jenkins start

exit 0

#EOF