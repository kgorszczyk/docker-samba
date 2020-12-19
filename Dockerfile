FROM ghcr.io/linuxserver/baseimage-ubuntu:bionic

# set version label
ARG BUILD_DATE
ARG VERSION
ARG SAMBA_RELEASE
LABEL build_version="Version:- ${VERSION} Build-date:- ${BUILD_DATE}"
LABEL maintainer="kgorszczyk"

# environment settings

RUN \
 echo "**** install packages ****" && \
 apt-get update && \
 apt-get install -y \
	acl attr autoconf bind9utils bison build-essential \
        debhelper dnsutils docbook-xml docbook-xsl flex gdb libjansson-dev \
        libacl1-dev libaio-dev libarchive-dev libattr1-dev libblkid-dev libbsd-dev \
        libcap-dev libcups2-dev libgnutls28-dev libgpgme-dev libjson-perl \
        libldap2-dev libncurses5-dev libpam0g-dev libparse-yapp-perl \
        libpopt-dev libreadline-dev nettle-dev perl perl-modules pkg-config \
        python-all-dev python-crypto python-dbus python-dev python-dnspython \
        python3-dnspython python-markdown python3-markdown libpython3-dev libdbus-1-dev \
        python3-dev xsltproc zlib1g-dev liblmdb-dev lmdb-utils wget && \
 mkdir -p /config && \
 wget https://download.samba.org/pub/samba/stable/samba-4.13.3.tar.gz && \
 tar -zxf samba-4.13.3.tar.gz && \
 cd samba-4.13.3 && \
 ./configure --sysconfdir=/config && \
 make -j 2 && \
 make install && \
 cp /samba-4.13.3/examples/smb.conf.default /config/. && \
 echo "**** cleanup ****" && \
 apt-get clean && \
 rm -rf \
	/tmp/* \
	/var/lib/apt/lists/* \
	/var/tmp/* \
        /samba-4.13.3 \
        /samba-4.13.3.tar.gz


COPY root/ /

# ports and volumes
EXPOSE 139 445
VOLUME /config
VOLUME /mnt
