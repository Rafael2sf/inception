#!/bin/bash

function check_envars()
{
	for ARG in "$@"; do
		if [ ! "${ARG#*=}" ]; then
			echo "[ERROR] $ARG: invalid environment variable" >&2
			exit 1
		fi
	done
}

function mysql_cmd()
{
	/usr/bin/mariadb -u root -p${MYSQL_ROOT_PASSWORD} -e "$1"
	if [ $? -ne 0 ]; then
		echo "failed running mysql command: $1" >&2
		exit 1
	fi
}

function run_safe()
{
	$1
	if [ $? -ne 0 ]; then
		echo "failed running command: $1" >&2
		exit 1
	fi
}

rc-status -a > /dev/null

if [ ! -d "/var/lib/mysql/mysql" ]; then
	check_envars \
		"MYSQL_ROOT_PASSWORD=${MYSQL_ROOT_PASSWORD}" \
		"MYSQL_DATABASE=${MYSQL_DATABASE}" \
		"MYSQL_USER=${MYSQL_USER}" \
		"MYSQL_USER_PASSWORD=${MYSQL_USER_PASSWORD}"
	# init
	run_safe "/usr/bin/mariadb-install-db \
		--defaults-file=/etc/my.cnf.d/mariadb-server.cnf"
	run_safe "rc-service mariadb start"

	# config db
	/usr/bin/mariadb -u root -e "ALTER USER 'root'@'localhost' \
		IDENTIFIED BY '${MYSQL_ROOT_PASSWORD}'"
	if [ $? -ne 0 ]; then
		echo "[ERROR]: Failed to set root password" >&2
		exit 2
	fi
	mysql_cmd "DROP USER IF EXISTS ''@'localhost'"
	mysql_cmd "DROP USER IF EXISTS ''@'$(hostname)'"
	mysql_cmd "DROP DATABASE IF EXISTS test"
	mysql_cmd "CREATE DATABASE IF NOT EXISTS ${MYSQL_DATABASE}"
	mysql_cmd "CREATE USER IF NOT EXISTS '${MYSQL_USER}'@'%' \
		IDENTIFIED BY '${MYSQL_USER_PASSWORD}'"
	mysql_cmd "GRANT ALL PRIVILEGES ON ${MYSQL_DATABASE}.* TO '${MYSQL_USER}'@'%' \
		IDENTIFIED BY '${MYSQL_USER_PASSWORD}'"
	mysql_cmd "FLUSH PRIVILEGES"

	# shutdown
	run_safe "/usr/bin/mysqladmin shutdown -p${MYSQL_ROOT_PASSWORD}"
else
	echo "[WARNING]: Detected '/var/lib/mysql/mysql/': \
database already exists, ignoring environment variables" >&2
fi

exec /usr/bin/mariadbd-safe
