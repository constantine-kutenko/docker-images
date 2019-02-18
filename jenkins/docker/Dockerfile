FROM centos:latest

# Define variables
ENV JENKINS_VERSION="2.60.3" \
    JENKINS_HOME="/var/jenkins_home" \
    JENKINS_TEMP="/tmp/jenkins_temp" \
    JENKINS_PLUGINS="/var/lib/jenkins/plugins"
    #ENV JENKINS_UC https://updates.jenkins.io
    #ENV JENKINS_URL http://updates.jenkins-ci.org/download/war/${JENKINS_VERSION}/jenkins.war

# Option JAVA_OPTS is used to disable the setup wizard so it's not needed since  setup will be fully automated
ENV JAVA_OPTS="-Djenkins.install.runSetupWizard=false" \
    JENKINS_OPTS="--handlerCountStartup=100 --handlerCountMax=300 --logfile=/var/log/jenkins/jenkins.log"

# Perform installation as root
USER root

# Install packages and dependencies
RUN yum install -y \
        epel-release \
        initscripts \
        curl \
        wget \
        sudo \
        java; \
    echo "jenkins ALL=NOPASSWD: ALL" >> /etc/sudoers && \
    mkdir /var/log/jenkins; \
    mkdir $JENKINS_TEMP; \
    curl http://pkg.jenkins-ci.org/redhat/jenkins.repo > /etc/yum.repos.d/jenkins.repo; \
    rpm --import http://pkg.jenkins-ci.org/redhat/jenkins-ci.org.key; \
    yum install -y jenkins; \
    yum clean all

# Update Jenkins from the Jenkins' website
#RUN wget -q -O /usr/share/jenkins/jenkins.war ${JENKINS_URL}

# Update Jenkins from a local source
#COPY updates/jenkins.war /usr/share/jenkins/jenkins.war
#ADD updates/jenkins.tar.gz /usr/share/jenkins/

### Copy configuration file and scripts

# Copy groovy scripts
COPY config/*.groovy /var/lib/jenkins/init.groovy.d/

# Copy shell scripts
COPY entrypoint.sh /entrypoint.sh
COPY install-plugins.sh /var/lib/jenkins/plugins/install-plugins.sh

# Copy a list of suggested plugins
COPY config/plugins_suggested.txt $JENKINS_TEMP/plugins_suggested.txt

# Copy SSH private keys
COPY keys/* $JENKINS_TEMP/

# Set permittions for Jenkins-related files and directories
RUN \
    chmod +x /entrypoint.sh; \
    chmod +x /var/lib/jenkins/plugins/install-plugins.sh; \
    chown -R jenkins:jenkins $JENKINS_TEMP/; \
    chown -R jenkins:jenkins /var/log/jenkins; \
    chown -R jenkins:jenkins /var/lib/jenkins

# Copy plugins manually
# COPY plugins/*.jpi /var/lib/jenkins/plugins/

# Download and install plugins for UpdateCenter
RUN /var/lib/jenkins/plugins/install-plugins.sh

# Start Jenkins
ENTRYPOINT ["/entrypoint.sh"]

# Drop back to the regular Jenkins user
# USER jenkins
