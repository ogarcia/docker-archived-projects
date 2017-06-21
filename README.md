# Grafana docker [![Build Status](https://travis-ci.org/ogarcia/docker-grafana.svg?branch=master)](https://travis-ci.org/ogarcia/docker-grafana)

(c) 2015-2017 Óscar García Amor Redistribution, modifications and pull
requests are welcomed under the terms of GPLv3 license.

[Grafana][1] is an open source, feature rich metrics dashboard and graph
editor for Graphite, Elasticsearch, OpenTSDB, Prometheus and InfluxDB.

This docker packages **Grafana** under [Alpine Linux][2], a lightweight
Linux distribution.

Visit [Docker Hub][3] to see all available tags.

[1]: https://grafana.com/
[2]: https://alpinelinux.org/
[3]: https://hub.docker.com/r/connectical/tor/

## Run

To run this container, simply exec.

```sh
docker run -d \
  --name=grafana \
  -p 3000:3000 \
  connectical/grafana
```

This start `grafana` and publish the port to host. You can go to
http://localhost:3000 to see it running.

Warning: this is a basic run, all data will be destroyed after container
stop.

## Persistent volumes

This container exports three volumes.

- /etc/grafana: config files
- /var/lib/grafana: grafana data
- /var/log/grafana: grafana logs

You can exec the following to store data.

```sh
docker run -d \
  --name=grafana \
  -p 3000:3000 \
  -v /srv/docker/grafana/cfg:/etc/grafana \
  -v /srv/docker/grafana/data:/var/lib/grafana \
  -v /srv/docker/grafana/log:/var/log/grafana \
  connectical/grafana
```

Take note that you must create before a valid config file in
`/srv/docker/grafana/cfg` and set ownership to UID/GID 100, otherwise the
main proccess will crash.

```sh
mkdir -p /srv/docker/grafana/cfg \
  /srv/docker/grafana/data \
  /srv/docker/grafana/log
chown -R 100:100 /srv/docker/grafana/data \
  /srv/docker/grafana/log
```

You can pick a sample config file from inside of container.

```sh
docker run -t -i --rm \
  --entrypoint=/bin/cat \
  connectical/grafana /etc/grafana/grafana.ini \
  > /srv/docker/grafana/cfg/grafana.ini
```

This generate a `/srv/docker/grafana/cfg/grafana.ini` in the persistent
volume.

## Shell run

If you can run a shell instead `grafana` command, simply do.

```sh
docker run -t -i --rm \
  --name=grafana \
  -p 3000:3000 \
  -v /srv/docker/grafana/cfg:/etc/grafana \
  -v /srv/docker/grafana/data:/var/lib/grafana \
  -v /srv/docker/grafana/log:/var/log/grafana \
  --entrypoint=/bin/sh \
  connectical/grafana
```

Please note that the `--rm` modifier destroy the docker after shell exit.
