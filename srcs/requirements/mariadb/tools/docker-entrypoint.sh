#!/bin/bash

function mysql_cmd()
{
	/usr/bin/mariadb -u root -proot -e "$1"
	if [ $? -ne 0 ]; then
		echo "failed running mysql command: $1" >&2
		exit 1
	fi
}

/usr/bin/mariadb-install-db \
	--defaults-file=/etc/my.cnf.d/mariadb-server.cnf \
	--auth-root-authentication-method=socket \
	--auth-root-socket-user=root \
	--datadir=/var/lib/mysql \
	--skip-test-db

# init mysql
/usr/bin/mariadbd-safe
/usr/bin/mariadb-admin shutdown
/usr/bin/mariadbd-safe

# set root pass without exiting if fails
/usr/bin/mariadb -u root -e "ALTER USER 'root'@'localhost' IDENTIFIED BY 'root'"

#if [ $? -eq 0 ]; then
#	mysql_cmd "DROP USER IF EXISTS ''@'localhost'"
#	mysql_cmd "DROP USER IF EXISTS ''@'$(hostname)'"
#	mysql_cmd "DROP DATABASE IF EXISTS test"
#fi
#
## Create provided database and user if dont exist
#mysql_cmd "CREATE USER IF NOT EXISTS 'user'@'%' IDENTIFIED BY 'user'"
#mysql_cmd "CREATE DATABASE IF NOT EXISTS test_db"
#mysql_cmd "GRANT ALL PRIVILEGES ON test_db.* TO 'user'@'%' IDENTIFIED BY 'user'"
#mysql_cmd "FLUSH PRIVILEGES"
#/usr/bin/mariadb -u root -e < /data/test.sql

# shutdown
/usr/bin/mariadb-admin shutdown

exec /usr/bin/mariadbd-safe
