FROM alpine:3.15

LABEL maintainer="Sergio Moura <sergio@moura.ca>"

RUN addgroup -g 101 mysql && adduser -h /var/lib/mysql -G mysql -g mysql -D -H -u 100 -s /bin/sh mysql
RUN mkdir -p /var/lib/mysql /run/mysqld && chown mysql:mysql /var/lib/mysql /run/mysqld

RUN apk add --update --no-cache mariadb mariadb-client pwgen

# Fix configuration files
RUN find /etc/my.cnf.d/ -name '*.cnf' -print0 | xargs -rt -0 sed -Ei 's/^(skip-network|bind-address|log|user\s)/#&/'

VOLUME /var/lib/mysql

COPY docker-entrypoint.sh /usr/local/bin/
ENTRYPOINT ["docker-entrypoint.sh"]

EXPOSE 3306

USER mysql
CMD ["mariadbd", "--bind-address=0.0.0.0"]
