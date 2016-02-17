# Chrome dockerfile
Dockerized Google Chrome

## Installation

Automated builds of this image are available on [Dockerhub][1] and is the
recommended method of installation.

```bash
docker pull ogarcia/chrome:latest
```

Alternatively, if you wish, you can build the image.

```bash
git clone https://github.com/ogarcia/dockerfiles.git
docker build -t chrome dockerfiles/chrome
```

## Launch

To launch simply run.

```bash
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

This command launchs the image passing your UID, GID and username. This is
necessary cause Chrome need run with the same UID and GID that you are
using in your Xserver to connect to display socket.

Take note that the image remains running in foreground for debug. If you
wish you can run as daemon, but remember delete it after run.

```bash
docker run -d \
  -e USER_UID=$(id -u) \
  -e USER_GID=$(id -g) \
  -e USER_NAME=$(id -u -n) \
  -e DISPLAY \
  -v /tmp/.X11-unix:/tmp/.X11-unix \
  --device /dev/snd \
  --name chrome \
  ogarcia/chrome
```

## Configuration

You can configure this docker via environment vars.

- **USER_UID**: Numeric UID for user that runs Chrome (Default: *1000*).
- **USER_GID**: Numeric GID for user that runs Chrome (Default: *1000*).
- **USER_NAME**: The sort user name of user that runs Chrome (Default: chrome).
- **USER_DATA_DIR**: Optional place to store Chrome data, use if you want
  export a persistent data volume.
- **ARGS**: Optional arguments to pass in command line to Chrome at launch.

Sample exporting persistent data volume in our home.

```bash
docker run -d \
  -e USER_UID=$(id -u) \
  -e USER_GID=$(id -g) \
  -e USER_NAME=$(id -u -n) \
  -e DISPLAY \
  -v /tmp/.X11-unix:/tmp/.X11-unix \
  --device /dev/snd \
  --name chrome \
  -e USER_DATA_DIR=/data \
  -v /home/$(id -u -n)/.config/google-chrome:/data \
  ogarcia/chrome
```

### Default Chrome configuration by policies

Chrome can be configurated using policies (you can read full docs in
[Chromium Project][2]).

This image insert two sample policies, the first install uBlock Origin
extension (an ads, trackers and malware blocker) and the second configure
a sample set of bookmars.

You can modify [this policies][3] and mount a volume with new set of
policies to preconfigure Chrome. This is very usefull if you don't persists
the config between sessions (fucking real anonymous mode).

Sample mounting a new policies directory stored in your `/opt/policies`.
Remember that inside this directory you must have a `managed` or
`recommended` (or both) directory with json files inside.

```bash
docker run -d \
  -e USER_UID=$(id -u) \
  -e USER_GID=$(id -g) \
  -e USER_NAME=$(id -u -n) \
  -e DISPLAY \
  -v /tmp/.X11-unix:/tmp/.X11-unix \
  --device /dev/snd \
  --name chrome \
  -v /opt/policies:/etc/opt/chrome/policies \
  ogarcia/chrome
```

[1]: https://hub.docker.com/r/ogarcia/chrome/
[2]: https://www.chromium.org/administrators/linux-quick-start
[3]: docker/policies
