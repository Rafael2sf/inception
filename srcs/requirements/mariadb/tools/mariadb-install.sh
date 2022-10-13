#!/bin/bash

function mysql_cmd()
{
	mysql -u root -p"${MYSQL_ROOT_PASSWORD}" -e "$1"
	if [ $? -ne 0 ]; then
		echo "Failed running mysql command: $1" >&2
		exit 1
	fi
}

# Allow remote connection from any ip
sed 's/127.0.0.1/0.0.0.0/g' -i /etc/mysql/mariadb.conf.d/50-server.cnf

if [ ! "$(mysql_install_db | grep failed)" ]; then
	/etc/init.d/mysql start
	mysqladmin -u root password "${MYSQL_ROOT_PASSWORD}"
	mysql_cmd "DROP USER IF EXISTS ''@'localhost'"
	mysql_cmd "DROP USER IF EXISTS ''@'$(hostname)'"
	mysql_cmd "DROP DATABASE IF EXISTS test"
else
	/etc/init.d/mysql start
fi

# Create provided database and user if dont exist
mysql_cmd "CREATE USER IF NOT EXISTS 'user'@'%' IDENTIFIED BY 'user'"
mysql_cmd "CREATE DATABASE IF NOT EXISTS test_db"
mysql_cmd "GRANT ALL PRIVILEGES ON test_db.* TO 'user'@'%' IDENTIFIED BY 'user'"
mysql_cmd "FLUSH PRIVILEGES"

exec mysqld_safe