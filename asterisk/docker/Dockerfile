FROM centos:7

ARG ASTERISK_VERSION=16.3.0
ARG ASTERISK_ADDONS_VERSION=1.6.2.4
ARG JANSSON_VERSION=2.11

ENV ASTERISK_USER=asterisk \
    ASTERISK_GROUP=asterisk \
    CONTAINER_UID=985 \
    CONTAINER_GID=977

COPY docker/entrypoint.sh /entrypoint.sh

RUN groupadd -f -g ${CONTAINER_GID} ${ASTERISK_GROUP} && \
    adduser -c "Asterisk Voice Platform" \
        --uid ${CONTAINER_UID} \
        --gid ${CONTAINER_GID} \
        --shell /usr/bin/nologin \
        --groups ${ASTERISK_GROUP} \
        --system \
        --no-create-home \
        ${ASTERISK_USER} && \
    yum update -y && \
    yum install -y \
    wget \
    bzip2 \
    libedit \
    libedit-devel \
    sqlite-devel \
    cpp \
    gcc \
    gcc-c++ \
    make \
    ncurses \
    ncurses-devel \
    libxml2 \
    libxml2-devel \
    openssl-devel \
    newt-devel \
    libuuid-devel \
    net-snmp-devel \
    tar \
    libffi-devel \
    sqlite-devel \
    curl \
    bison \
    patch && \
    wget -qO- http://www.digip.org/jansson/releases/jansson-${JANSSON_VERSION}.tar.gz | tar xz -C /usr/local/src && \
    cd /usr/local/src/jansson-${JANSSON_VERSION} && \
    ./configure && \
    make clean && \
    make && make install && \
    ldconfig && \
    wget -qO- https://downloads.asterisk.org/pub/telephony/asterisk/asterisk-${ASTERISK_VERSION}.tar.gz | tar xz -C /usr/local/src && \
    cd /usr/local/src/asterisk-${ASTERISK_VERSION} && \
    ./configure \
        --libdir=/usr/lib64 \
        --with-jansson-bundled && \
    make menuselect/menuselect menuselect-tree menuselect.makeopts && \
    menuselect/menuselect --disable-category MENUSELECT_CORE_SOUNDS menuselect.makeopts && \
    menuselect/menuselect --disable-category MENUSELECT_MOH menuselect.makeopts && \
    menuselect/menuselect --disable-category MENUSELECT_EXTRA_SOUNDS menuselect.makeopts && \
    : ${JOBS:=$(( $(nproc) + $(nproc) / 2 ))} && \
    make -j ${JOBS} all && \
    make install && \
    make samples && \
    chown -R ${ASTERISK_USER}:${ASTERISK_GROUP} \
        /etc/asterisk \
        /var/*/asterisk \
        /usr/*/asterisk \
        /usr/lib64/asterisk && \
    chmod -R 750 /var/spool/asterisk && \
    rm -rf /var/cache/yum && \
    chmod +x /entrypoint.sh

EXPOSE 5060/udp 5060/tcp

VOLUME /etc/asterisk \
    /var/lib/asterisk \
    /var/spool/asterisk \
    /var/log/asterisk

LABEL name="asterisk" \
      description="Asterisk is an open source communications platform that can handle voice, video and text communications from an IP Network (VoIP) and the PSTN." \
      component.asterisk.version="${ASTERISK_VERSION}"

USER ${ASTERISK_USER}:${ASTERISK_GROUP}

ENTRYPOINT ["/entrypoint.sh"]

CMD ["/usr/sbin/asterisk", "-vvvdddf", "-T", "-W", "-U", "asterisk", "-p", "-n"]
