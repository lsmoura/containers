FROM alpine:3.16.2

LABEL maintainer="Sergio Moura <sergio@moura.ca>"
LABEL org.opencontainers.image.source="https://github.com/lsmoura/containers/sickchill"
LABEL org.opencontainers.image.description="SickChill is an automatic Video Library Manager for TV Shows."

RUN apk add --no-cache \
		libmediainfo \
		libssl1.1 \
		libxslt \
		py3-pip \
		python3

RUN \
	apk add --no-cache --virtual .build-deps \
		cargo \
		g++ \
		gcc \
		git \
		libffi-dev \
		libxslt-dev \
		make \
		openssl-dev \
		python3-dev && \
	ln -s /usr/bin/python3 /usr/bin/python && \
	pip3 install -U pip && \
	pip3 install --upgrade --prefer-binary poetry pip wheel setuptools && \
	apk del .build-deps && \
	rm -Rf ${HOME}/.cache ${HOME}/.local

## UNRAR
ARG UNRAR_VERSION=6.1.7
RUN apk add --update --no-cache libstdc++ && \
  apk add --update --no-cache --virtual .build-deps build-base curl && \
  cd /tmp && \
  curl -LO https://www.rarlab.com/rar/unrarsrc-${UNRAR_VERSION}.tar.gz && \
  tar zxf unrarsrc-${UNRAR_VERSION}.tar.gz && \
  cd unrar && \
  make && make install && \
  apk del .build-deps && \
  cd /tmp && rm -Rf unrar unrarsrc-${UNRAR_VERSION}.tar.gz

ARG VERSION=2022.8.30
RUN apk add --no-cache --virtual .build-deps curl build-base python3-dev && \
	cd /opt && \
	curl -Lo SickChill-${VERSION}.zip https://github.com/SickChill/SickChill/archive/refs/tags/${VERSION}.zip && \
	unzip SickChill-${VERSION}.zip && rm SickChill-${VERSION}.zip && \
	mv SickChill-${VERSION}/ sickchill && \
	cd /opt/sickchill && \
	python3 -m pip install . && \
	cd /tmp && \
	apk del .build-deps && \
	rm -Rf /opt/sickchill ${HOME}/.cache ${HOME}/.local

VOLUME /data /downloads /tv

EXPOSE 8081

CMD python3 /usr/bin/SickChill --nolaunch --datadir /config --port 8081
