#!/bin/bash

wp core download
if [ $? -eq 0 ]; then
	wp config create --dbname=test_db --dbuser=user --dbpass=user --dbhost=mdb
	chmod 644 wp-config.php
	wp core install \
		--url=rafernan.42.fr \
		--title="test_web" \
		--admin_name=admin \
		--admin_password=admin \
		--admin_email=rafaelmdsbni@gmail.com
else
	wp core config --dbuser=user --dbpass=user
fi

#	echo "must provide all of the following environment \
#variables: MYSQL_DATABASE MYSQL_USER MYSQL_USER_PASSWORD" >&2
#	exit 1

exec /usr/sbin/php-fpm8 -F -R
