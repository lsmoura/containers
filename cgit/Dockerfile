FROM alpine:3.17.0

LABEL maintainer="Sergio Moura <sergio@moura.ca>"
LABEL org.opencontainers.image.source="https://github.com/lsmoura/containers/cgit"

RUN apk add --update --no-cache fcgiwrap nginx supervisor spawn-fcgi

ARG VERSION=1.2.3
RUN apk add --update --no-cache --virtual .build-deps curl build-base git openssl-dev libintl libressl-dev musl-libintl zlib-dev zlib && \
  cd /tmp && \
  curl -LO https://git.zx2c4.com/cgit/snapshot/cgit-${VERSION}.zip && \
  unzip cgit-${VERSION}.zip && rm cgit-${VERSION}.zip && \
  cd /tmp/cgit-${VERSION} && \
  make get-git && \
  NO_ICONV=YesPlease NO_GETTEXT=YesPlease NO_TCLTK=YesPlease NO_SVN_TESTS=YesPlease NO_REGEX=NeedsStartEnd NO_LUA=1 prefix=/usr make && \
  NO_ICONV=YesPlease NO_GETTEXT=YesPlease NO_TCLTK=YesPlease NO_SVN_TESTS=YesPlease NO_REGEX=NeedsStartEnd NO_LUA=1 prefix=/usr make install && \
  cd /tmp && \
  apk del .build-deps && \
  rm -Rf /tmp/cgit-${VERSION}

COPY default.conf /etc/nginx/http.d/
COPY nginx.conf /etc/nginx/
COPY supervisord.conf cgitrc /etc/

RUN mkdir -p /git

VOLUME ["/git"]

ENV PYTHONUNBUFFERED=True 
ENV PYTHONIOENCODING=UTF-8

CMD supervisord -n -c /etc/supervisord.conf
