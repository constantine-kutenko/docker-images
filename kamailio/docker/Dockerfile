FROM registry.example.com/centos as builder

ARG KAMAILIO_VERSION=5.1

ENV KAMAILIO_VERSION=${KAMAILIO_VERSION} \
    KAMAILIO_USER=kamailio \
    KAMAILIO_GROUP=kamailio \
    CONTAINER_UID=409 \
    CONTAINER_GID=609

RUN yum install -y \
        git make which bison flex clang libxml2 pcre2 pcre2-tools pcre2-devel gcc-c++ \
        json-devel jsoncpp-devel json-c-devel jansson jansson-devel libpqxx libpqxx-devel \
        openssl-libs libcurl libcurl-devel libev libev-devel hiredis hiredis-devel libevent \
        libevent-devel libxslt libxslt-devel openssl openssl-devel GeoIP GeoIP-devel \
        amqp amqp-devel librabbitmq-devel libuuid-devel openldap-devel libmemcached-devel \
        mysql++-devel perl-devel postgresql-devel python-devel radiusclient-ng-devel \
        lksctp-tools-devel net-snmp-devel sqlite-devel unixODBC-devel libwebsockets-devel \
        libunistring-devel expat-devel libxml2-devel json-parser-devel lua-devel && \
    cd /tmp && \
    git clone -b ${KAMAILIO_VERSION} https://github.com/kamailio/kamailio.git && \
    cd kamailio && \
    make include_modules="evapi auth_xkeys carrierroute cnxcc cplc crypto debugger dialplan dmq_usrloc geoip gzcompress http_async_client http_client imc jansson json kazoo lcr ldap memcached db_mysql outbound db_postgres presence app_python acc_radius auth_radius misc_radius ndb_redis topos_redis regex rtjson sctp snmpstats db_sqlite statsd tcpops tls db_unixodbc utils uuid websocket xhttp xhttp_pi xhttp_rpc xmlops xmlrpc xmpp tm tmrec tmx kex corex sl rr pv maxfwd usrloc registrar textops siputils xlog sanity ctl cfg_rpc acc counters jsonrpcs app_lua" modules && \
    make \
        prefix=/ \
        CC_EXTRA_OPTS=-I/usr/include/libxml2 \
        group_include="standard standard-dep stable presence mysql" \
        all && \
    make prefix=/ install && \
    rm -rf /tmp/kamailio

FROM registry.example.com/centos

#
#
#

ENV KAMAILIO_VERSION=${KAMAILIO_VERSION} \
    KAMAILIO_USER=kamailio \
    KAMAILIO_GROUP=kamailio \
    CONTAINER_UID=409 \
    CONTAINER_GID=609

COPY --from=builder /etc/kamailio /etc/kamailio
COPY --from=builder /usr/sbin /usr/sbin
COPY --from=builder /usr/lib64/kamailio /usr/lib64/kamailio
COPY --from=builder /share/kamailio /share/kamailio
COPY docker/entrypoint.sh /entrypoint.sh

RUN groupadd -f -g ${CONTAINER_GID} ${KAMAILIO_GROUP} && \
    useradd -u ${CONTAINER_UID} -g ${CONTAINER_GID} -s /sbin/nologin -M ${KAMAILIO_USER} && \
    echo -e  '[irontec]\nname=Irontec RPMs repository\nbaseurl=http://packages.irontec.com/centos/$releasever/$basearch/'> /etc/yum.repos.d/irontec.repo && \
    rpm --import http://packages.irontec.com/public.key && \
    rpm -i https://dev.mysql.com/get/mysql57-community-release-el7-11.noarch.rpm && \
    yum install -y --skip-broken \
        hiredis \
        hiredis-devel \
        mariadb-libs mariadb-devel \
        json-c-devel \
        librabbitmq-devel \
        libevent \
        libunistring-devel \
        libev-devel \
        mysql-community-client \
        mysql-community-libs-compat \
        nmap-ncat \
        sngrep \
        wireshark \
        tcpdump && \
    usermod -a -G wireshark kamailio && \
    chmod u+s,g+x,o+x /usr/sbin/tshark /usr/sbin/dumpcap && \
    chmod u+s /usr/bin/sngrep /usr/sbin/tcpdump && \
    mkdir -p /var/run/kamailio && \
    chown -R ${KAMAILIO_USER}:${KAMAILIO_GROUP} /usr/sbin/kam* /etc/kamailio /usr/lib64/kamailio /share/kamailio /var/run/kamailio /entrypoint.sh && \
    chmod +x /entrypoint.sh

LABEL name="kamailio" \
      description="Kamailio is an Open Source SIP Server able to handle thousands of call setups per second" \
      component.kamailio.version="${KAMAILIO_VERSION}"

EXPOSE 5060/tcp 5064/tcp 5065/tcp 5060/udp 5064/udp 5065/udp

USER ${KAMAILIO_USER}:${KAMAILIO_GROUP}

ENTRYPOINT ["/entrypoint.sh"]

CMD ["kamailio"]
