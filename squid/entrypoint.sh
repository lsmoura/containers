#!/bin/sh

# Allow logging to stdout for any user
chmod 777 /proc/self/fd/1

mkdir -p /etc/squid/conf.d

EXTRACONF=$(cat /etc/squid/conf.d/*.conf | sed "s|\/|\\\/|g")

# update squid.conf

sed -i "s/^##conf.d##.*$/${EXTRACONF}/g" /etc/squid/squid.conf

exec "$@"