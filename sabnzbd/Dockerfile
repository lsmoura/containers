FROM alpine:3.14.3

LABEL maintainer="Sergio Moura <sergio@moura.ca>"

RUN apk add --update --no-cache curl python3 py3-pip libffi openssl unrar p7zip libgomp

WORKDIR /tmp
ARG PAR2VERSION=0.8.1
RUN curl -LO https://github.com/Parchive/par2cmdline/releases/download/v${PAR2VERSION}/par2cmdline-${PAR2VERSION}.tar.gz && \
tar zxf par2cmdline-${PAR2VERSION}.tar.gz && \
rm -f par2cmdline-${PAR2VERSION}.tar.gz && \
cd par2cmdline-${PAR2VERSION} && \
apk add --no-cache --virtual .build-deps build-base automake autoconf && \
./automake.sh && \
./configure && \
make && make check && make install && \
apk del .build-deps && \
cd /tmp && rm -Rf par2cmdline-${PAR2VERSION}

ARG VERSION=3.4.2

WORKDIR /opt
RUN mkdir -p /opt && cd /opt && \
  curl -LO https://github.com/sabnzbd/sabnzbd/releases/download/$VERSION/SABnzbd-${VERSION}-src.tar.gz && \
  tar zxf SABnzbd-${VERSION}-src.tar.gz && \
  rm -f SABnzbd-${VERSION}-src.tar.gz

WORKDIR /opt/SABnzbd-${VERSION}

RUN apk add --no-cache --virtual .build-deps build-base python3-dev py3-wheel libffi-dev openssl-dev rust cargo && \
  python3 -m pip install -r requirements.txt && \
  apk del .build-deps

EXPOSE 8080/tcp

VOLUME ["/config"]

CMD ["./SABnzbd.py", "--config-file", "/config/sabnzbd.ini", "--server", "0.0.0.0:8080", "--disable-file-log", "--nobrowser"]
