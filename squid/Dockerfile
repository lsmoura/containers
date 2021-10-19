FROM alpine:3.14

LABEL maintainer="Sergio Moura <https://sergio.moura.ca>"

RUN apk add --no-cache squid

RUN mkdir -p /etc/squid/conf.d && touch /etc/squid/conf.d/empty.conf

COPY entrypoint.sh /
COPY squid.conf /etc/squid/squid.conf

EXPOSE 3128

ENTRYPOINT ["/entrypoint.sh"]

CMD ["/usr/sbin/squid", "-N"]
