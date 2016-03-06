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
