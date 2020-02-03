ARG ALPINE_VERSION

FROM alpine:${ALPINE_VERSION}
ARG GRAFANA_VERSION
COPY .circleci /grafana/build
ADD https://github.com/grafana/grafana/archive/v${GRAFANA_VERSION}.tar.gz /grafana/src/grafana.tar.gz
RUN /grafana/build/build.sh

FROM alpine:${ALPINE_VERSION}
COPY --from=0 /grafana/pkg /
EXPOSE 3000
VOLUME [ "/etc/grafana", "/var/lib/grafana", "/var/log/grafana" ]
USER grafana
ENTRYPOINT [ "/bin/grafana-server", "-homepath", "/usr/share/grafana", "-config", "/etc/grafana/grafana.ini" ]
