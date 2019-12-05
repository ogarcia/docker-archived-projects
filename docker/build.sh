#! /bin/sh
#
# build.bash
# Copyright (C) 2017-2018 Óscar García Amor <ogarcia@connectical.com>
#
# Distributed under terms of the MIT license.
#

# add edge repository
echo "@edge http://dl-cdn.alpinelinux.org/alpine/edge/main" >> /etc/apk/repositories
echo "@edge http://dl-cdn.alpinelinux.org/alpine/edge/community" >> /etc/apk/repositories

# upgrade
apk -U --no-progress upgrade

# install build deps
apk --no-progress add g++ git go@edge make musl-dev nodejs nodejs-npm python

# extract software
cd /tmp/build
tar xzf grafana.tar.gz

# build grafana
export GOPATH="/tmp/build/gopath"
export GRAFANAPATH="${GOPATH}/src/github.com/grafana/grafana"
mkdir -p ${GRAFANAPATH%/*}
ln -fsT /tmp/build/grafana-* ${GRAFANAPATH}
cd ${GRAFANAPATH}
patch -p1 <"/tmp/docker/defaults.patch"
go run build.go setup build
npm install -g yarn
yarn install --pure-lockfile --no-progress
npm run build release

# install grafana
install -D -m755 "${GRAFANAPATH}/bin/linux-amd64/grafana-cli" \
  "/usr/bin/grafana-cli"
install -D -m755 "${GRAFANAPATH}/bin/linux-amd64/grafana-server" \
  "/usr/bin/grafana-server"
install -D -m644 "${GRAFANAPATH}/conf/defaults.ini" \
  "/usr/share/grafana/conf/defaults.ini"
mv ${GRAFANAPATH}/public /usr/share/grafana/
mv ${GRAFANAPATH}/vendor /usr/share/grafana/
install -D -m644 "${GRAFANAPATH}/conf/sample.ini" \
  "/etc/grafana/grafana.ini"
install -D -m644 "${GRAFANAPATH}/conf/ldap.toml" \
  "/etc/grafana/ldap.toml"

# create grafana user
adduser -S -D -H -h /var/lib/grafana -s /sbin/nologin -G users \
  -g grafana grafana
mkdir -p /var/lib/grafana
chown grafana:users /var/lib/grafana

# remove build deps
apk --no-progress del g++ git go make musl-dev nodejs nodejs-npm python
rm -rf /root/.ash_history /root/.cache /root/.config /root/.node-gyp \
  /root/.npm /root/.yarnrc /tmp/* /usr/bin/yarn* /usr/lib/go \
  /usr/lib/node_modules /usr/local/share/.cache /usr/local/share/.config \
  /var/cache/apk/*
