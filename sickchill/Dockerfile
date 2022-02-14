FROM alpine:3.14.3

LABEL maintainer="Sergio Moura <sergio@moura.ca>"
LABEL org.opencontainers.image.source="https://github.com/lsmoura/containers/sickchill"

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
	apk add --no-cache \
		libmediainfo \
		libssl1.1 \
		libxslt \
		py3-pip \
		python3 \
		unrar && \
	ln -s /usr/bin/python3 /usr/bin/python && \
	pip3 install -U pip && \
	pip3 install --upgrade --prefer-binary poetry pip wheel setuptools && \
	apk del .build-deps && \
	rm -Rf ${HOME}/.cache ${HOME}/.local

RUN apk add --cache --virtual .build-deps git && \
	mkdir -p /opt/sickchill && \
	git clone --depth 1 https://github.com/SickChill/SickChill.git /opt/sickchill && \
	cd /opt/sickchill && \
	python3 -m pip install . && \
	cd /tmp && \
	apk del .build-deps && \
	rm -Rf /opt/sickchill ${HOME}/.cache ${HOME}/.local

VOLUME /data /downloads /tv

EXPOSE 8081

CMD python3 /usr/bin/SickChill --nolaunch --datadir /config --port 8081
