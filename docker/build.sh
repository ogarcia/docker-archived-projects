#! /bin/sh
#
# build.bash
# Copyright (C) 2017 Óscar García Amor <ogarcia@connectical.com>
#
# Distributed under terms of the MIT license.
#

# add edge repository
echo "@edge http://dl-cdn.alpinelinux.org/alpine/edge/main" >> /etc/apk/repositories
echo "@edge http://dl-cdn.alpinelinux.org/alpine/edge/community" >> /etc/apk/repositories

# upgrade
apk -U --no-progress upgrade

# install build deps
apk --no-progress add g++ git go@edge

# extract software
cd /tmp/build
tar xzf influxdb.tar.gz

# build influxdb
export GOPATH="/tmp/build/gopath"
export GOBIN="${GOPATH}/bin"
export INFLUXDBPATH="${GOPATH}/src/github.com/influxdata/influxdb"
mkdir -p ${INFLUXDBPATH%/*}
ln -fsT /tmp/build/influxdb-* ${INFLUXDBPATH}
cd ${INFLUXDBPATH}
go get github.com/sparrc/gdm
${GOBIN}/gdm restore
go install -ldflags "-X main.version=1.4.3" ./...

# install influxdb
install -D -m755 "${GOBIN}/influxd" "/usr/bin/influxd"
install -D -m755 "${GOBIN}/influx" "/usr/bin/influx"
install -D -m644 "${INFLUXDBPATH}/etc/config.sample.toml" \
  "/etc/influxdb/influxdb.conf"

# create influxdb user
adduser -S -D -H -h /var/lib/influxdb -s /sbin/nologin -G users \
  -g influxdb influxdb
mkdir -p /var/lib/influxdb
chown influxdb:users /var/lib/influxdb

# remove build deps
apk --no-progress del g++ git go
rm -rf /root/.ash_history /tmp/* /var/cache/apk/* /var/cache/misc/*
