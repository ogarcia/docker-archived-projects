ALPINE_VERSION := 3.11
GRAFANA_VERSION := 6.6.0
DOCKER_USER := ogarcia
DOCKER_ORGANIZATION := connectical
DOCKER_IMAGE := grafana
DOCKER_IMAGE_NAME ?= $(DOCKER_ORGANIZATION)_$(DOCKER_IMAGE).tar

all: docker-build docker-test

check-env:
ifndef DOCKERHUB_USERNAME
	$(error DOCKERHUB_USERNAME is undefined)
endif
ifndef DOCKERHUB_PASSWORD
	$(error DOCKERHUB_PASSWORD is undefined)
endif

docker-build:
	docker build -t $(DOCKER_ORGANIZATION)/$(DOCKER_IMAGE) --build-arg ALPINE_VERSION=$(ALPINE_VERSION) --build-arg GRAFANA_VERSION=$(GRAFANA_VERSION) .

docker-test:
	docker image inspect $(DOCKER_ORGANIZATION)/$(DOCKER_IMAGE)
	docker run --rm $(DOCKER_ORGANIZATION)/$(DOCKER_IMAGE) -v

docker-save:
	docker image inspect $(DOCKER_ORGANIZATION)/$(DOCKER_IMAGE)
	docker save -o $(DOCKER_IMAGE_NAME) $(DOCKER_ORGANIZATION)/$(DOCKER_IMAGE)

docker-load:
ifneq ($(wildcard $(DOCKER_IMAGE_NAME)),)
	docker load -i $(DOCKER_IMAGE_NAME)
endif

docker-push: check-env
	echo "${DOCKERHUB_PASS}" | docker login -u "${DOCKERHUB_USERNAME}" --password-stdin
	docker push $(DOCKER_ORGANIZATION)/$(DOCKER_IMAGE):latest
ifdef CIRCLE_TAG
	docker tag $(DOCKER_ORGANIZATION)/$(DOCKER_IMAGE):latest $(DOCKER_ORGANIZATION)/$(DOCKER_IMAGE):${CIRCLE_TAG}
	docker push $(DOCKER_ORGANIZATION)/$(DOCKER_IMAGE):${CIRCLE_TAG}
endif

.PHONY: all check-env docker-build docker-test docker-save docker-push
# vim:ft=make
