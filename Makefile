DOCKER_USER := ogarcia
DOCKER_ORGANIZATION := ogarcia
DOCKER_IMAGE := archlinux

docker-image: rootfs
	docker build -t $(DOCKER_ORGANIZATION)/$(DOCKER_IMAGE) .

docker-image-test: docker-image
	docker run --rm $(DOCKER_ORGANIZATION)/$(DOCKER_IMAGE) sh -c "/usr/bin/pacman -V"
	docker run --rm $(DOCKER_ORGANIZATION)/$(DOCKER_IMAGE) sh -c "/usr/bin/pacman -Syu --noconfirm docker && docker -v"

ci-test:
	docker run --rm --privileged --tmpfs=/tmp:exec --tmpfs=/run/shm -v /run/docker.sock:/run/docker.sock \
		-v $(PWD):/app -w /app $(DOCKER_ORGANIZATION)/$(DOCKER_IMAGE) \
		sh -c 'pacman -Syu --noconfirm make devtools docker && make docker-image-test'

rootfs:
	$(eval TMPDIR := $(shell mktemp -d))
	pacstrap -C $(DOCKER_IMAGE)/pacman.conf -c -d -G -M $(TMPDIR) $(shell cat $(DOCKER_IMAGE)/packages)
	cp --recursive --preserve=timestamps --backup --suffix=.pacnew $(DOCKER_IMAGE)/rootfs/* $(TMPDIR)/
	arch-chroot $(TMPDIR) locale-gen
	arch-chroot $(TMPDIR) pacman-key --init
	arch-chroot $(TMPDIR) pacman-key --populate archlinux
	tar --numeric-owner --xattrs --acls --exclude-from=$(DOCKER_IMAGE)/exclude -C $(TMPDIR) -c . -f archlinux.tar
	rm -rf $(TMPDIR)

clean:
	rm -f archlinux.tar

.PHONY: docker-image docker-image-test ci-test rootfs clean
