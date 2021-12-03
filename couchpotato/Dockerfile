FROM alpine:3.14.3

LABEL maintainer="Sergio Moura <https://sergio.moura.ca/>"
ENV PYTHONIOENCODING="UTF-8"

RUN apk add --update --no-cache python2 libxml2 libffi libxslt

# Python dependencies
RUN apk add --update --no-cache --virtual .build-deps build-base python2-dev openssl-dev libffi-dev libxml2-dev libxslt-dev && \
  python2 -m 'ensurepip' && \
  pip install --upgrade pip && \
  pip install pyopenssl lxml && \
  apk del .build-deps

WORKDIR /app
RUN apk add --update --no-cache --virtual .install-deps git build-base && \
   git clone --depth 1 https://github.com/CouchPotato/CouchPotatoServer.git . && \
   rm -Rf .git .github init .gitignore .editorconfig .coveragerc && \
   python2 -m 'ensurepip' && \
   pip install pyopenssl && \
   apk del .install-deps && \
   mkdir -p /data /config

VOLUME /config
VOLUME /data

EXPOSE 5050

CMD ["python", "CouchPotato.py", "--data_dir", "/data", "--config_file", "/config/config.ini", "--console_log"]
