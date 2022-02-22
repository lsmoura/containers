FROM alpine:3.15.0

LABEL maintainer="Sergio Moura <sergio@moura.ca>"
LABEL org.opencontainers.image.source="https://github.com/lsmoura/containers/sabnzbd"

RUN apk add --update --no-cache curl python3 py3-pip libffi openssl p7zip libgomp

WORKDIR /tmp

## PAR2
ARG PAR2VERSION=0.8.1
RUN apk add --update  --no-cache --virtual .build-deps build-base automake autoconf && \
  curl -LO https://github.com/Parchive/par2cmdline/releases/download/v${PAR2VERSION}/par2cmdline-${PAR2VERSION}.tar.gz && \
  tar zxf par2cmdline-${PAR2VERSION}.tar.gz && \
  cd par2cmdline-${PAR2VERSION} && \
  ./automake.sh && \
  ./configure && \
  make && make check && make install && \
  apk del .build-deps && \
  cd /tmp && rm -Rf par2cmdline-${PAR2VERSION} par2cmdline-${PAR2VERSION}.tar.gz

## UNRAR
ARG UNRAR_VERSION=6.1.4
RUN apk add --update --no-cache libstdc++ && \
  apk add --update --no-cache --virtual .build-deps build-base curl && \
  curl -LO https://www.rarlab.com/rar/unrarsrc-${UNRAR_VERSION}.tar.gz && \
  tar zxf unrarsrc-${UNRAR_VERSION}.tar.gz && \
  cd unrar && \
  make && make install && \
  apk del .build-deps && \
  cd /tmp && rm -Rf unrar unrarsrc-${UNRAR_VERSION}.tar.gz

## SABNZBD
ARG VERSION=3.5.0
WORKDIR /opt
RUN mkdir -p /opt && cd /opt && \
  curl -LO https://github.com/sabnzbd/sabnzbd/releases/download/$VERSION/SABnzbd-${VERSION}-src.tar.gz && \
  tar zxf SABnzbd-${VERSION}-src.tar.gz && \
  rm -f SABnzbd-${VERSION}-src.tar.gz

WORKDIR /opt/SABnzbd-${VERSION}
RUN apk add --no-cache --virtual .build-deps build-base python3-dev py3-wheel libffi-dev openssl-dev rust cargo && \
  python3 -m pip install --requirement requirements.txt && \
  apk del .build-deps && \
  rm -Rf ${HOME}/.cache ${HOME}/.cargo

EXPOSE 8080/tcp

VOLUME ["/config"]

CMD ["./SABnzbd.py", "--config-file", "/config/sabnzbd.ini", "--server", "0.0.0.0:8080", "--disable-file-log", "--nobrowser"]
