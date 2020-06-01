#! /bin/sh
#
# build.bash
# Copyright (C) 2017-2020 Óscar García Amor <ogarcia@connectical.com>
#
# Distributed under terms of the MIT license.
#

# add edge repository
echo "@edge http://dl-cdn.alpinelinux.org/alpine/edge/main" >> /etc/apk/repositories
echo "@edge http://dl-cdn.alpinelinux.org/alpine/edge/community" >> /etc/apk/repositories

# upgrade
apk -U --no-progress upgrade

# install build deps
apk --no-progress add g++ git go@edge make musl-dev nodejs nodejs-npm patch

# extract software
cd /grafana/src/
tar xzf grafana.tar.gz

# build grafana
export GOPATH="/grafana/src/gopath"
mkdir -p "${GOPATH}/src/github.com/grafana/"
ln -fsT /grafana/src/grafana-* "${GOPATH}/src/github.com/grafana/grafana"
cd "${GOPATH}/src/github.com/grafana/grafana"
patch -p1 <"/grafana/build/defaults.patch"
go run build.go setup build
npm install -g yarn
yarn install --pure-lockfile --no-progress
npm run build release

# install grafana
install -D -m755 "bin/linux-amd64/grafana-cli" \
  "/grafana/pkg/bin/grafana-cli"
install -D -m755 "bin/linux-amd64/grafana-server" \
  "/grafana/pkg/bin/grafana-server"
install -D -m644 "conf/defaults.ini" \
  "/grafana/pkg/usr/share/grafana/conf/defaults.ini"
mv "public" "/grafana/pkg/usr/share/grafana/"
mv "vendor" "/grafana/pkg/usr/share/grafana/"
install -D -m644 "conf/sample.ini" \
  "/grafana/pkg/etc/grafana/grafana.ini"
install -D -m644 "conf/ldap.toml" \
  "/grafana/pkg/etc/grafana/ldap.toml"
install -d -m755 -o100 -g100 "/grafana/pkg/var/lib/grafana" \
  "/grafana/pkg/var/log/grafana"

# create grafana user
adduser -S -D -H -h /var/lib/grafana -s /sbin/nologin -G users \
  -g grafana grafana
install -m644 "/etc/passwd" "/grafana/pkg/etc/passwd"
install -m644 "/etc/group" "/grafana/pkg/etc/group"
install -m640 -gshadow "/etc/shadow" "/grafana/pkg/etc/shadow"
