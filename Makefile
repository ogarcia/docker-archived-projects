DOCKER_ORGANIZATION ?= ogarcia
DOCKER_IMAGE ?= archlinux
DOCKER_TAG ?= base
DOCKER_IMAGE_FILENAME ?= $(DOCKER_ORGANIZATION)_$(DOCKER_IMAGE)_$(DOCKER_TAG).tar

all: rootfs docker-build docker-test

all-in-docker: rootfs-in-docker docker-build docker-test

check-dockerhub-env:
ifndef DOCKERHUB_USERNAME
	$(error DOCKERHUB_USERNAME is undefined)
endif
ifndef DOCKERHUB_PASSWORD
	$(error DOCKERHUB_PASSWORD is undefined)
endif

check-quay-env:
ifndef QUAY_USERNAME
	$(error QUAY_USERNAME is undefined)
endif
ifndef QUAY_PASSWORD
	$(error QUAY_PASSWORD is undefined)
endif

clean:
	rm -f rootfs.tar
	rm -f $(DOCKER_IMAGE_FILENAME)

mrproper: clean
	docker image rm $(DOCKER_ORGANIZATION)/$(DOCKER_IMAGE):$(DOCKER_TAG) > /dev/null 2>&1 || true

rootfs:
	$(eval TMPDIR := $(shell mktemp -d))
	pacstrap -C $(DOCKER_TAG)/pacman.conf -c -d -G -M $(TMPDIR) $(shell cat $(DOCKER_TAG)/packages)
	cp --recursive --preserve=timestamps --backup --suffix=.pacnew $(DOCKER_TAG)/rootfs/* $(TMPDIR)/
	mount --bind $(TMPDIR) $(TMPDIR)
	arch-chroot $(TMPDIR) locale-gen
	mount --bind $(TMPDIR) $(TMPDIR)
	arch-chroot $(TMPDIR) pacman-key --init
	sleep 2 && mountpoint -q $(TMPDIR) && umount -R $(TMPDIR)
	mount --bind $(TMPDIR) $(TMPDIR)
	arch-chroot $(TMPDIR) pacman-key --populate archlinux
	sleep 2 && mountpoint -q $(TMPDIR) && umount -R $(TMPDIR)
	tar --numeric-owner --xattrs --acls --exclude-from=$(DOCKER_TAG)/exclude -C $(TMPDIR) -c . -f rootfs.tar
	mountpoint -q $(TMPDIR) || rm -rf $(TMPDIR)

rootfs-in-docker:
	docker run --rm --privileged --tmpfs=/tmp:exec --tmpfs=/run/shm -v /run/docker.sock:/run/docker.sock \
		-e DOCKER_TAG=$(DOCKER_TAG) -v $(shell pwd):/app -w /app $(DOCKER_ORGANIZATION)/$(DOCKER_IMAGE) sh -c \
		'pacman -Sy --noprogressbar --noconfirm --needed archlinux-keyring && pacman -Syu --noprogressbar --noconfirm --needed make devtools && make rootfs'

docker-build:
	docker build -t $(DOCKER_ORGANIZATION)/$(DOCKER_IMAGE):$(DOCKER_TAG) .

docker-test:
	docker image inspect $(DOCKER_ORGANIZATION)/$(DOCKER_IMAGE):$(DOCKER_TAG)
	docker run --rm $(DOCKER_ORGANIZATION)/$(DOCKER_IMAGE):$(DOCKER_TAG) sh -c "/usr/bin/pacman -V"

docker-save:
	docker image inspect $(DOCKER_ORGANIZATION)/$(DOCKER_IMAGE):$(DOCKER_TAG) > /dev/null 2>&1
	docker save -o $(DOCKER_IMAGE_FILENAME) $(DOCKER_ORGANIZATION)/$(DOCKER_IMAGE):$(DOCKER_TAG)

docker-load:
ifneq ($(wildcard $(DOCKER_IMAGE_FILENAME)),)
	docker load -i $(DOCKER_IMAGE_FILENAME)
endif

dockerhub-push: check-dockerhub-env
	$(eval DOCKER_VERSION_TAG := $(shell date +%Y.%m.%d))
	echo "${DOCKERHUB_PASSWORD}" | docker login -u "${DOCKERHUB_USERNAME}" --password-stdin
	docker tag $(DOCKER_ORGANIZATION)/$(DOCKER_IMAGE):$(DOCKER_TAG) $(DOCKER_ORGANIZATION)/$(DOCKER_IMAGE):$(DOCKER_VERSION_TAG)-$(DOCKER_TAG)
	docker push $(DOCKER_ORGANIZATION)/$(DOCKER_IMAGE):$(DOCKER_TAG)
	docker push $(DOCKER_ORGANIZATION)/$(DOCKER_IMAGE):$(DOCKER_VERSION_TAG)-$(DOCKER_TAG)
ifeq ($(DOCKER_TAG),base)
	docker tag $(DOCKER_ORGANIZATION)/$(DOCKER_IMAGE):$(DOCKER_TAG) $(DOCKER_ORGANIZATION)/$(DOCKER_IMAGE):$(DOCKER_VERSION_TAG)
	docker tag $(DOCKER_ORGANIZATION)/$(DOCKER_IMAGE):$(DOCKER_TAG) $(DOCKER_ORGANIZATION)/$(DOCKER_IMAGE):latest
	docker push $(DOCKER_ORGANIZATION)/$(DOCKER_IMAGE):$(DOCKER_VERSION_TAG)
	docker push $(DOCKER_ORGANIZATION)/$(DOCKER_IMAGE):latest
endif

quay-push: check-quay-env
	$(eval DOCKER_VERSION_TAG := $(shell date +%Y.%m.%d))
	echo "${QUAY_PASSWORD}" | docker login -u "${QUAY_USERNAME}" --password-stdin quay.io
	docker tag $(DOCKER_ORGANIZATION)/$(DOCKER_IMAGE):$(DOCKER_TAG) quay.io/$(DOCKER_ORGANIZATION)/$(DOCKER_IMAGE):$(DOCKER_TAG)
	docker tag $(DOCKER_ORGANIZATION)/$(DOCKER_IMAGE):$(DOCKER_TAG) quay.io/$(DOCKER_ORGANIZATION)/$(DOCKER_IMAGE):$(DOCKER_VERSION_TAG)-$(DOCKER_TAG)
	docker push quay.io/$(DOCKER_ORGANIZATION)/$(DOCKER_IMAGE):$(DOCKER_TAG)
	docker push quay.io/$(DOCKER_ORGANIZATION)/$(DOCKER_IMAGE):$(DOCKER_VERSION_TAG)-$(DOCKER_TAG)
ifeq ($(DOCKER_TAG),base)
	docker tag $(DOCKER_ORGANIZATION)/$(DOCKER_IMAGE):$(DOCKER_TAG) quay.io/$(DOCKER_ORGANIZATION)/$(DOCKER_IMAGE):$(DOCKER_VERSION_TAG)
	docker tag $(DOCKER_ORGANIZATION)/$(DOCKER_IMAGE):$(DOCKER_TAG) quay.io/$(DOCKER_ORGANIZATION)/$(DOCKER_IMAGE):latest
	docker push quay.io/$(DOCKER_ORGANIZATION)/$(DOCKER_IMAGE):$(DOCKER_VERSION_TAG)
	docker push quay.io/$(DOCKER_ORGANIZATION)/$(DOCKER_IMAGE):latest
endif

.PHONY: all all-in-docker check-dockerhub-env check-quay-env clean mrproper rootfs rootfs-in-docker docker-build docker-test docker-save docker-load dockerhub-push quay-push
# vim:ft=make
