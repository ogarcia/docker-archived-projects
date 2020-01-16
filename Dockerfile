FROM alpine:3.10
COPY docker /grafana/docker
ADD https://github.com/grafana/grafana/archive/v6.5.3.tar.gz /grafana/src/grafana.tar.gz
RUN /grafana/docker/build.sh

FROM alpine:3.10
COPY --from=0 /grafana/pkg /
EXPOSE 3000
VOLUME [ "/etc/grafana", "/var/lib/grafana", "/var/log/grafana" ]
USER grafana
ENTRYPOINT [ "/bin/grafana-server", "-homepath", "/usr/share/grafana", "-config", "/etc/grafana/grafana.ini" ]
