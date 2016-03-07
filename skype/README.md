# Skype dockerfile

Dockerized Skype

## Launch

```
docker run -ti --rm \
  -e USER_UID=$(id -u) \
  -e USER_GID=$(id -g) \
  -e USER_NAME=$(id -u -n) \
  -e DISPLAY \
  -e TZ=$(date +%Z) \
  -v /tmp/.X11-unix:/tmp/.X11-unix \
  -v /run/user/$(id -u)/pulse:/run/pulse \
  -v $(xdg-user-dir DOWNLOAD):/home/$(id -u -n)/Downloads \
  -v ${HOME}/.config/skype:/home/$(id -u -n)/.Skype \
  --name skype \
  ogarcia/skype
```

## Desktop entry

If you wish you can create a desktop file to have a fancy icon to launch
Skype. Simply create a `~/.local/share/applications/skype-docker.desktop`
file with the following contents.

```
[Desktop Entry]
Type=Application
Encoding=UTF-8
Name=Skype
Comment=Dockerized Skype
Exec=/usr/bin/docker run --rm -e ARGS=%U -e USER_UID=1000 -e USER_GID=1000 -e USER_NAME=ogarcia -e DISPLAY -e TZ=CET -v /tmp/.X11-unix:/tmp/.X11-unix -v /run/user/ogarcia/pulse:/run/pulse -v /home/ogarcia/Descargas:/home/ogarcia/Downloads -v /home/ogarcia/.config/skype:/home/ogarcia/.Skype --name skype ogarcia/skype
Icon=skype.png
Terminal=false
Categories=Network;Application;
MimeType=x-scheme-handler/skype;
X-KDE-Protocols=skype
```

Note that you must set the variables for match with your environment.
