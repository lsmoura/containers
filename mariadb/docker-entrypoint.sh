#!/bin/sh

set -e

start_server_bg() {
	mariadbd &
	for i in {30..0}; do
		if $(echo 'select 1' | mariadb mysql &> /dev/null); then
			break
		fi
		sleep 1
	done
	if [ "$i" = 0 ]; then
		echo "Unable to start server."
		exit 1
	fi
}

stop_server_bg() {
	if ! mariadb-admin shutdown -uroot -p${MARIADB_ROOT_PASSWORD}; then
		echo "Unable to shut down server."
		exit 1
	fi
}

init() {
	mariadb-install-db --auth-root-authentication-method=normal --datadir=/var/lib/mysql --skip-test-db
	start_server_bg
	MARIADB_ROOT_PASSWORD="$(pwgen --capitalize --numerals --ambiguous -1 32)"
	mariadb -uroot --database=mysql --binary-mode <<-EOSQL
		SET @@SESSION.SQL_LOG_BIN=0;
		SET @@SESSION.SQL_MODE=REPLACE(@@SESSION.SQL_MODE, 'NO_BACKSLASH_ESCAPES', '');

		SET PASSWORD FOR 'root'@'localhost'=PASSWORD('${MARIADB_ROOT_PASSWORD}');
		GRANT ALL ON *.* TO 'root'@'localhost' WITH GRANT OPTION;
		FLUSH PRIVILEGES;
		CREATE USER 'root'@'%' IDENTIFIED BY '${MARIADB_ROOT_PASSWORD}';
		GRANT ALL ON *.* TO 'root'@'%' WITH GRANT OPTION;
		DROP DATABASE IF EXISTS test;
	EOSQL
	echo "Root password is ${MARIADB_ROOT_PASSWORD}"

	if [ -n "$MARIADB_DATABASE" ]; then
		echo "Creating database ${MARIADB_DATABASE}"
		mariadb -uroot --database=mysql --binary-mode -p${MARIADB_ROOT_PASSWORD} <<-EOSQL
			CREATE DATABASE IF NOT EXISTS \`${MARIADB_DATABASE}\`;
		EOSQL
	fi

	if [ -n "$MARIADB_USER" ] && [ -n "$MARIADB_PASSWORD" ]; then
		mariadb -uroot --database=mysql --binary-mode -p${MARIADB_ROOT_PASSWORD} <<-EOSQL
			SET @@SESSION.SQL_MODE=REPLACE(@@SESSION.SQL_MODE, 'NO_BACKSLASH_ESCAPES', '');
			CREATE USER '${MARIADB_USER}'@'%' IDENTIFIED BY '${MARIADB_PASSWORD}';
		EOSQL

		if [ -n "$MARIADB_DATABASE" ]; then
			echo "Giving user ${MARIADB_USER} access to ${MARIADB_DATABASE}"
			mariadb -uroot --database=mysql --binary-mode -p${MARIADB_ROOT_PASSWORD} <<-EOSQL
				GRANT ALL ON \`${MARIADB_DATABASE}\`.* TO '${MARIADB_USER}'@'%';
			EOSQL
		fi
	fi
	stop_server_bg
}

# Only run this if the database mysql does not exists
if [ ! -d /var/lib/mysql/mysql ]; then
	init
fi

exec $@
