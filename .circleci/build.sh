#! /bin/sh
#
# build.bash
# Copyright (C) 2017-2020 Óscar García Amor <ogarcia@connectical.com>
#
# Distributed under terms of the MIT license.
#

# upgrade
apk -U --no-progress upgrade

# install build deps
apk --no-progress add g++ git go

# extract software
cd /influxdb/src/
tar xzf influxdb.tar.gz

# build influxdb
export GOPATH="/influxdb/src/gopath"
export GOBIN="${GOPATH}/bin"
mkdir -p "${GOPATH}/src/github.com/influxdata/"
ln -fsT /influxdb/src/influxdb-* "${GOPATH}/src/github.com/influxdata/influxdb"
cd "${GOPATH}/src/github.com/influxdata/influxdb"
go get -v -u github.com/golang/dep/cmd/dep
${GOBIN}/dep ensure -v -vendor-only
go install -ldflags "-X main.version=${1}" ./...

# install influxdb
install -D -m755 "${GOBIN}/influxd" "/influxdb/pkg/usr/bin/influxd"
install -D -m755 "${GOBIN}/influx" "/influxdb/pkg/usr/bin/influx"
install -D -m644 "${GOPATH}/src/github.com/influxdata/influxdb/etc/config.sample.toml" \
  "/influxdb/pkg/etc/influxdb/influxdb.conf"
install -d -m755 -o100 -g100 "/influxdb/pkg/var/lib/influxdb"

# create influxdb user
adduser -S -D -H -h /var/lib/influxdb -s /sbin/nologin -G users \
  -g influxdb influxdb
install -m644 "/etc/passwd" "/influxdb/pkg/etc/passwd"
install -m644 "/etc/group" "/influxdb/pkg/etc/group"
install -m640 -gshadow "/etc/shadow" "/influxdb/pkg/etc/shadow"
