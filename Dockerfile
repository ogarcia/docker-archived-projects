FROM alpine:3.5

COPY . /tmp/

ADD https://github.com/grafana/grafana/archive/v4.3.2.tar.gz /tmp/build/v4.3.2.tar.gz

RUN /tmp/docker/build.sh

EXPOSE 3000

VOLUME [ "/etc/grafana", "/var/lib/grafana", "/var/log/grafana" ]

USER grafana

ENTRYPOINT [ "/usr/bin/grafana-server", "-homepath", "/usr/share/grafana", "-config", "/etc/grafana/grafana.ini" ]
