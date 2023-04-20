ARG ALPINE_VERSION

FROM alpine:${ALPINE_VERSION}
RUN apk add nextcloud-client
COPY entrypoint.sh /entrypoint.sh

ENV HOME /data

VOLUME ["/data"]

ENTRYPOINT ["/entrypoint.sh"]
