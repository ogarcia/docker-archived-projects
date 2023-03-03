ARG ALPINE_VERSION

FROM alpine:${ALPINE_VERSION}
RUN apk add dbus-x11 gnome-keyring libsecret mesa-dri-gallium nextcloud-client x11vnc xvfb
COPY .circleci/entrypoint.sh /entrypoint.sh

EXPOSE 5900

ENV XNUM 99
ENV XRES 800x600x24
ENV VNCPASS 123456
ENV HOME /data

VOLUME ["/data"]

ENTRYPOINT ["/entrypoint.sh"]
