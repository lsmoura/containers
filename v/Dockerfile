FROM alpine:3.18

LABEL maintainer="Sergio Moura <https://sergio.moura.ca/>"
LABEL org.opencontainers.image.source="https://github.com/lsmoura/containers/v"

WORKDIR /opt/vlang
ENV VVV /opt/vlang

RUN apk add --update --no-cache --virtual .tinycc-build-deps build-base curl git && \
	mkdir -p /opt/tinycc && cd /opt/tinycc && \
	git clone git://repo.or.cz/tinycc.git . && ./configure --prefix=/usr --config-musl && make && make install && \
	cd /opt && rm -Rf /opt/tinycc && \
	apk del .tinycc-build-deps

ARG VVERSION=0.4
ARG VFLAGS=-prod
COPY alpine.patch.diff .
RUN apk add --update --no-cache --virtual .install-deps curl git && \
	apk add --update --no-cache build-base elfutils-dev gc-dev && \
	curl -LO https://github.com/vlang/v/archive/refs/tags/${VVERSION}.tar.gz && \
	tar zxf ${VVERSION}.tar.gz --strip-components=1 && \
	patch -p1 < alpine.patch.diff && \
	git clone --filter=blob:none https://github.com/vlang/vc vc/ && \
	cc -std=gnu11 -w -o v1 vc/v.c -lm -lelf -lpthread && \
	./v1 -no-parallel -o v2 ${VFLAGS} cmd/v && \
	./v2 -o v ${VFLAGS} cmd/v && \
	./v run ./cmd/tools/detect_tcc.v && \
	apk del .install-deps && rm -Rf v1 v2 vc v-${VVERSION}.tar.gz

RUN ./v run ./cmd/tools/vsymlink.v && \
	/usr/local/bin/v version

ENTRYPOINT ["/usr/local/bin/v"]