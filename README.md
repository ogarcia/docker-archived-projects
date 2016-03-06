# dockerfiles
Dockerfiles for several user applications

## Run Chrome

Pull the image from Docker Hub and run.

```bash
docker pull ogarcia/chrome
docker run -ti --rm \
  -e USER_UID=$(id -u) \
  -e USER_GID=$(id -g) \
  -e USER_NAME=$(id -u -n) \
  -e DISPLAY \
  -v /tmp/.X11-unix:/tmp/.X11-unix \
  --device /dev/snd \
  --name chrome \
  ogarcia/chrome
```

To get more info and hack this build you can read its [specific readme][1].

## Run Skype

Pull the image from Docker Hub and run.

```bash
docker pull ogarcia/skype
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

To get more info and hack this build you can read its [specific readme][2].

[1]: chrome/README.md
[2]: skype/README.md
