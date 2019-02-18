FROM registry.example.com/debian:jessie

ARG FREESWITCH_VERSION=1.6

ENV FREESWITCH_USER=freeswitch \
    FREESWITCH_GROUP=freeswitch

COPY docker/entrypoint.sh /entrypoint.sh
COPY ./app/config/odbcinst.ini /etc/odbcinst.ini

RUN addgroup -q ${FREESWITCH_GROUP} && \
    adduser --gecos "FreeSWITCH Voice Platform" --no-create-home --disabled-login --disabled-password --system --ingroup ${FREESWITCH_GROUP} ${FREESWITCH_USER} && \
    curl -sL https://files.freeswitch.org/repo/deb/debian/freeswitch_archive_g0.pub | apt-key add - && \
    echo "deb http://files.freeswitch.org/repo/deb/freeswitch-${FREESWITCH_VERSION}/ jessie main" > /etc/apt/sources.list.d/freeswitch.list && \
    apt-get -y update && \
    apt-get -y upgrade && \
    apt-get install -y \
      freeswitch \
      freeswitch-mod-console \
      freeswitch-mod-syslog \
      freeswitch-mod-xml-curl \
      freeswitch-mod-odbc-cdr \
      freeswitch-mod-event-socket \
      freeswitch-mod-sofia \
      freeswitch-mod-commands \
      freeswitch-mod-conference \
      freeswitch-mod-dptools \
      freeswitch-mod-expr \
      freeswitch-mod-dialplan-xml \
      freeswitch-mod-spandsp \
      freeswitch-mod-g723-1 \
      freeswitch-mod-g729 \
      freeswitch-mod-amr \
      freeswitch-mod-h26x \
      freeswitch-mod-b64 \
      freeswitch-mod-isac \
      freeswitch-mod-opus \
      freeswitch-mod-sndfile \
      freeswitch-mod-native-file \
      freeswitch-mod-png \
      freeswitch-mod-local-stream \
      freeswitch-mod-tone-stream \  
      freeswitch-mod-lua \
      freeswitch-mod-say-en \
      xmlstarlet \
      unixodbc \
      libmyodbc \
      tcpdump && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* && \
    chown -R ${FREESWITCH_USER}:${FREESWITCH_GROUP} \
        /etc/freeswitch \
        /run/freeswitch \
        /usr/bin/freeswitch \
        /usr/lib/freeswitch \
        /usr/share/doc/freeswitch \
        /var/lib/freeswitch \
        /var/log/freeswitch \
        /etc/odbcinst.ini \
        /etc/odbc.ini && \
    chgrp ${FREESWITCH_GROUP} /etc && \
    chmod g+rwx /etc && \
    chmod u+s /usr/sbin/tcpdump && \
    chmod +x /entrypoint.sh

EXPOSE 5060/tcp 5060/udp 5080/tcp 5080/udp 5066/tcp 7443/tcp 8021/tcp 10000-20000/udp

LABEL name="freeswitch" \
      description="FreeSWITCH is an open source communications platform that can handle voice, video and text communications from an IP Network (VoIP) and the PSTN." \
      component.freeswitch.version="${FREESWITCH_VERSION}"

USER ${FREESWITCH_USER}:${FREESWITCH_GROUP}

ENTRYPOINT ["/entrypoint.sh"]

CMD ["freeswitch"]
