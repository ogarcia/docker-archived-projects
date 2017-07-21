# InfluxDB docker [![Build Status](https://travis-ci.org/ogarcia/docker-influxdb.svg?branch=master)](https://travis-ci.org/ogarcia/docker-influxdb)

(c) 2017 Óscar García Amor

Redistribution, modifications and pull requests are welcomed under the terms
of GPLv3 license.

[InfluxDB][1] is an open source time series database with no external
dependencies. It's useful for recording metrics, events, and performing
analytics.

This docker packages **InfluxDB** under [Alpine Linux][2], a lightweight
Linux distribution.

Visit [Docker Hub][3] to see all available tags.

[1]: https://www.influxdata.com/
[2]: https://alpinelinux.org/
[3]: https://hub.docker.com/r/connectical/influxdb/

## Run

To run this container, simply exec.

```sh
docker run -d \
  --name=influxdb \
  -p 8086:8086 \
  connectical/influxdb
```

This start `influxdb` and publish the port to host. You can go to
http://localhost:8086 to see it running.

Warning: this is a basic run, all data will be destroyed after container
stop.

## Persistent volumes

This container exports two volumes.

- /etc/influxdb: config files
- /var/lib/influxdb: influxdb data

You can exec the following to store data.

```sh
docker run -d \
  --name=influxdb \
  -p 8086:8086 \
  -v /srv/docker/influxdb/cfg:/etc/influxdb \
  -v /srv/docker/influxdb/data:/var/lib/influxdb \
  connectical/influxdb
```

Take note that you must create before a valid config file in
`/srv/docker/influxdb/cfg` and set ownership to UID/GID 100, otherwise the
main proccess will crash.

```sh
mkdir -p /srv/docker/influxdb/cfg \
  /srv/docker/influxdb/data
chown -R 100:100 /srv/docker/influxdb/data
```

You can pick a sample config file from inside of container.

```sh
docker run -t -i --rm \
  --entrypoint=/bin/cat \
  connectical/influxdb /etc/influxdb/influxdb.conf \
  > /srv/docker/influxdb/cfg/influxdb.conf
```

This generate a `/srv/docker/influxdb/cfg/influxdb.conf` in the persistent
volume.

## Shell run

If you can run a shell instead `influxd` command, simply do.

```sh
docker run -t -i --rm \
  --name=influxdb \
  -p 8086:8086 \
  -v /srv/docker/influxdb/cfg:/etc/influxdb \
  -v /srv/docker/influxdb/data:/var/lib/influxdb \
  --entrypoint=/bin/sh \
  connectical/influxdb
```

Please note that the `--rm` modifier destroy the docker after shell exit.
