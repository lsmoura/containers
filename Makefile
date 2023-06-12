SABNZBD_VERSION=4.0.2
UNRAR_VERSION=6.2.7
SABNZBD_IMAGE_PREFIX=ghcr.io/lsmoura/sabnzbd

SICKCHILL_VERSION=2022.10.8
SICKCHILL_IMAGE_PREFIX=ghcr.io/lsmoura/sickchill

build-sickchill-all:
	docker build --platform linux/amd64 --tag $(SICKCHILL_IMAGE_PREFIX):$(SICKCHILL_VERSION)-amd64 --build-arg VERSION=$(SICKCHILL_VERSION) --progress plain sickchill
	docker build --platform linux/arm64 --tag $(SICKCHILL_IMAGE_PREFIX):$(SICKCHILL_VERSION)-arm64 --build-arg VERSION=$(SICKCHILL_VERSION) --progress plain sickchill

build-sickchill-parallel:
	parallel --tag --verbose --line-buffer \
	docker build --platform linux/{1} --tag $(SICKCHILL_IMAGE_PREFIX):$(SICKCHILL_VERSION)-{1} --build-arg VERSION=$(SICKCHILL_VERSION) --progress plain sickchill \
	::: amd64 arm64

update-sickchill: build-sickchill-all
	docker push $(SICKCHILL_IMAGE_PREFIX):$(SICKCHILL_VERSION)-amd64
	docker push $(SICKCHILL_IMAGE_PREFIX):$(SICKCHILL_VERSION)-arm64
	docker manifest create $(SICKCHILL_IMAGE_PREFIX):$(SICKCHILL_VERSION) $(SICKCHILL_IMAGE_PREFIX):$(SICKCHILL_VERSION)-amd64 $(SICKCHILL_IMAGE_PREFIX):$(SICKCHILL_VERSION)-arm64
	docker manifest push $(SICKCHILL_IMAGE_PREFIX):$(SICKCHILL_VERSION)

build-sabnzbd-amd64:
	docker build --platform linux/amd64 --tag $(SABNZBD_IMAGE_PREFIX):$(SABNZBD_VERSION)-amd64 --build-arg VERSION=$(SABNZBD_VERSION) --build-arg UNRAR_VERSION=$(UNRAR_VERSION) --progress plain - < sabnzbd/Dockerfile

build-sabnzbd-arm64:
	docker build --platform linux/arm64 --tag ${SABNZBD_IMAGE_PREFIX}:$(SABNZBD_VERSION)-arm64 --build-arg VERSION=$(SABNZBD_VERSION) --build-arg UNRAR_VERSION=$(UNRAR_VERSION) --progress plain - < sabnzbd/Dockerfile

build-sabnzbd-all: build-sabnzbd-amd64 build-sabnzbd-arm64

build-sabnzbd-parallel:
	parallel --tag --verbose --line-buffer \
	docker build --platform linux/{1} --tag $(SABNZBD_IMAGE_PREFIX):$(SABNZBD_VERSION)-{1} --build-arg VERSION=$(SABNZBD_VERSION) --build-arg UNRAR_VERSION=$(UNRAR_VERSION) --progress plain sabnzbd \
	::: amd64 arm64

update-sabnzbd: build-sabnzbd-all
	docker push $(SABNZBD_IMAGE_PREFIX):$(SABNZBD_VERSION)-amd64
	docker push $(SABNZBD_IMAGE_PREFIX):$(SABNZBD_VERSION)-arm64
	docker manifest create $(SABNZBD_IMAGE_PREFIX):$(SABNZBD_VERSION) $(SABNZBD_IMAGE_PREFIX):$(SABNZBD_VERSION)-amd64 $(SABNZBD_IMAGE_PREFIX):$(SABNZBD_VERSION)-arm64
	docker manifest push $(SABNZBD_IMAGE_PREFIX):$(SABNZBD_VERSION)
