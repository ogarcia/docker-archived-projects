ARG ALPINE_VERSION

FROM alpine:${ALPINE_VERSION} AS builder
ARG INFLUXDB_VERSION
COPY .circleci /influxdb/build
ADD https://github.com/influxdata/influxdb/archive/v${INFLUXDB_VERSION}.tar.gz /influxdb/src/influxdb.tar.gz
RUN /influxdb/build/build.sh ${INFLUXDB_VERSION}

FROM alpine:${ALPINE_VERSION}
COPY --from=builder /influxdb/pkg /
EXPOSE 8086
VOLUME [ "/etc/influxdb", "/var/lib/influxdb" ]
USER influxdb
ENTRYPOINT [ "/usr/bin/influxd" ]
