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
  chrome
```

To get more info and hack this build you can read its [specific readme][1].

[1]: (chrome/README.md).
