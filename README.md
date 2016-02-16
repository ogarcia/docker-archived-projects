# dockerfiles
Dockerfiles for several user applications

## Run Chrome

Clone this repo and run.

```bash
docker build -t chrome chrome
docker run -ti --rm \
  -v /tmp/.X11-unix:/tmp/.X11-unix \
  -e DISPLAY \
  --device /dev/snd \ # to have sound
  chrome
```

If you wish you can run as daemon, but remember delete it after run.

```bash
docker run -d
  -v /tmp/.X11-unix:/tmp/.X11-unix \
  -e DISPLAY \
  --device /dev/snd \ # to have sound
  --name chrome \
  chrome
```

By default chrome run inside docker with UID/GID 1000 and user chrome. You
can set different UID, GID and username with environment vars.

```bash
docker run -d
  -v /tmp/.X11-unix:/tmp/.X11-unix \
  -e DISPLAY \
  -e USER_UID=500
  -e USER_GID=500
  -e USER_NAME=mrpotato
  --device /dev/snd \ # to have sound
  --name chrome \
  chrome
```

Take note that the UID/GID must match with your user UID/GID to avoid
problems with Xauthority.
