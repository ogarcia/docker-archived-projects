# Docker images for Arch Linux  [![Tests Status](https://travis-ci.org/ogarcia/docker-archlinux.svg?branch=master)](https://travis-ci.org/ogarcia/docker-archlinux) [![Publish Status](https://drone.moire.org/api/badges/ogarcia/docker-archlinux/status.svg)](https://drone.moire.org/ogarcia/docker-archlinux)

This repository contains all the scripts and files needed to create various
Docker image flavors of the Arch Linux distribution.

## Dependencies

Install the following Arch Linux packages:

* docker
* make
* devtools

## Usage

Run `make` as **root** to build the `archlinux-base` image.

You can build the other targets by setting the `DOCKER_IMAGE` variable when
calling the make command.

```sh
make DOCKER_IMAGE=archlinux-devel
```
