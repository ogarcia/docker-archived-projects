FROM debian:jessie
MAINTAINER Oscar Garcia Amor (https://ogarcia.me)

RUN dpkg --add-architecture i386 \
 && apt-get update \
 && apt-get install -y curl --no-install-recommends \
 && curl http://download.skype.com/linux/skype-debian_4.3.0.37-1_i386.deb > /usr/src/skype.deb \
 && dpkg --force-depends -i /usr/src/skype.deb \
 && apt-get install -fy \
 && apt-get install -y fonts-cantarell --no-install-recommends \
 && rm -rf /usr/src/skype.deb && rm -rf /var/lib/apt/lists/*

COPY docker/entrypoint.sh /sbin/entrypoint.sh

ENTRYPOINT ["/sbin/entrypoint.sh"]
