FROM alpine:3.7

COPY docker /tmp/docker

ADD https://github.com/influxdata/influxdb/archive/v1.5.1.tar.gz /tmp/build/influxdb.tar.gz

RUN /tmp/docker/build.sh

EXPOSE 8086

VOLUME [ "/etc/influxdb", "/var/lib/influxdb" ]

USER influxdb

ENTRYPOINT [ "/usr/bin/influxd" ]
