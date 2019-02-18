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

set -e

# Download plugins
/plugins.sh

# Run Jenkins
echo -e "${green}\n>>> Jenkins is starting...${reset}"
#/bin/bash -c "/etc/rc.d/init.d/jenkins start"
/etc/rc.d/init.d/jenkins start

echo -e "${green}\n>>> Please wait 5 to 10 seconds before using Jenkins.${reset}"

exec "$@"
#sh -c '$@'

while :; do
    sleep 300
done

#EOF