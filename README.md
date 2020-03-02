# Docker images for Arch Linux [![CircleCI](https://circleci.com/gh/ogarcia/docker-archlinux.svg?style=svg)](https://circleci.com/gh/ogarcia/docker-archlinux)

(c) 2017-2020 Óscar García Amor

This repository contains all the scripts and files needed to create various
Docker image flavors of the Arch Linux distribution.

## About tags

At this moment, two images of Arch Linux are building.

- **base**: default image with basic system.
- **devel**: the basic system with base-devel package group.

Tag format used is as following.

- **base**: `YYYY.MM.DD`, `YYYY.MM.DD-base`, `base`, `latest`
- **devel**: `YYYY.MM.DD-devel`, `devel`

Old images are archived with format `YYYY.MM.DD` and `YYYY.MM.DD-base` for
base and `YYYY.MM.DD-devel` for devel.

Visit [Docker Hub][1] or [Quay][2] to see all available tags.

[1]: https://hub.docker.com/r/ogarcia/archlinux/
[2]: https://quay.io/repository/ogarcia/archlinux/

## Dependencies for build in your Arch Linux host

Install the following Arch Linux packages:

* docker
* make
* devtools

## Usage

Run `make` as **root** to build the `archlinux` basic image rootfs in temp
directory of your host, run `make all-in-docker` to build rootfs in
a container (for example if your host is not based in Arch Linux).

You can build the other targets by setting the `DOCKER_TAG` variable when
calling the make command.

```sh
make DOCKER_TAG=devel
```
