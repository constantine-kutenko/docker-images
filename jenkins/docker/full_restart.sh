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

clear

# Stop Jenkins
echo -e "${green}>>> Stopping Jenkins instance${reset}"
/etc/init.d/jenkins stop

# Clear current configuration
echo -e "${green}>>> Cleaning up Jenkins configuration${reset}"
rm -rf /var/lib/jenkins/jobs/*
rm -rf /var/lib/jenkins/logs/*
rm -rf /var/lib/jenkins/plugins/*
rm -rf /var/lib/jenkins/users/*
echo "" > /var/log/jenkins/jenkins.log

# Install plugins and restart Jenkins
echo -e "${green}>>> Configuring and running Jenkins...${reset}"
. ./plugins.sh

#EOF