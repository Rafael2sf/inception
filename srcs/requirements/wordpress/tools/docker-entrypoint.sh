#!/bin/bash
CONFIG_FILE="/var/www/rafernan.42.fr/wp-config.php"

function wp_set()
{
	local prev=`grep $1 wp-config.php | awk '{print $3}'`
	sed "s/$prev/'$2'/g" -i "$CONFIG_FILE"
}

if [ -z "$(ls /var/www/rafernan.42.fr/)" ]; then
	# Install trought website
	wget https://wordpress.org/latest.tar.gz > /dev/null
	if [ $? -ne 0 ]; then
		exit 1
	fi

	tar -xzvf latest.tar.gz > /dev/null
	rm latest.tar.gz
	mv wordpress/* .
	rm -rf wordpress/

	# setup wp-config
	mv /var/www/rafernan.42.fr/wp-config-sample.php $CONFIG_FILE

	wp_set "localhost" "mdb"
fi

if [ "${MYSQL_DATABASE}" ] && [ "${MYSQL_USER}" ] && \
	[ "${MYSQL_USER_PASSWORD}" ]
then
	wp_set "DB_NAME" "${MYSQL_DATABASE}"
	wp_set "DB_USER" "${MYSQL_USER}"
	wp_set "DB_PASSWORD" "${MYSQL_USER_PASSWORD}"
else
	echo "must provide all of the following environment \
variables: MYSQL_DATABASE MYSQL_USER MYSQL_USER_PASSWORD" >&2
	exit 1
fi

exec /usr/sbin/php-fpm8 -F -R
