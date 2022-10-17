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

function wait_port()
{
	local TIMEOUT_COUNTER=0

	while ! nc -z $1 $2; do
		((TIMEOUT_COUNTER=TIMEOUT_COUNTER+2))
		if [ $TIMEOUT_COUNTER -eq $3 ]; then
			echo "[ERROR]: connection to database: timeout" >&2
			exit 1
		fi
		echo "[-]: connection to database: atempt failed" >&2
		sleep 2
	done
	echo "[OK]: connection to database: success" >&2
}

function error_status()
{
	if [ $? -ne 0 ]; then
		echo "[ERROR]: $1"
		exit 1
	fi
}

wait_port "mdb" "3306" 30

if [ ! -f "wp-config.php" ]; then
	check_envars \
		"MYSQL_DATABASE=${MYSQL_DATABASE}" \
		"MYSQL_USER=${MYSQL_USER}" \
		"MYSQL_USER_PASSWORD=${MYSQL_USER_PASSWORD}" \
		"WP_ADMIN=${WP_ADMIN}" \
		"WP_ADMIN_PASSWORD=${WP_ADMIN_PASSWORD}" \
		"WP_ADMIN_EMAIL=${WP_ADMIN_EMAIL}" \
		"WP_USER=${WP_USER}" \
		"WP_USER_PASSWORD=${WP_USER_PASSWORD}" \
		"WP_USER_EMAIL=${WP_USER_EMAIL}"

	# init config
	wp config create \
		--dbname=${MYSQL_DATABASE} \
		--dbuser=${MYSQL_USER} \
		--dbpass=${MYSQL_USER_PASSWORD} \
		--dbhost=mdb
	error_status "failed to create config"

	# core install with administrator
	chmod 644 wp-config.php
	wp core install \
		--url=rafernan.42.fr \
		--title=inception \
		--admin_name=${WP_ADMIN} \
		--admin_password=${WP_ADMIN_PASSWORD} \
		--admin_email=${WP_ADMIN_EMAIL}
	error_status "failed to install wp"

	# Create user
	wp user create ${WP_USER} ${WP_USER_EMAIL} \
		--user_pass=${WP_USER_PASSWORD} --role=author
	error_status "failed to create user on wp database"
else
	echo "[WARNING]: Detected 'wp-config.php': \
wordpress already exists, ignoring environment variables" >&2
fi

exec /usr/sbin/php-fpm8 -F -R
