#!/bin/bash

if [ "$(ls /var/www/rafernan.42.fr | grep wordpress)" ]; then
	echo "Wordpress is already installed"
else
	echo "Installing wordpress"
	wget https://wordpress.org/latest.tar.gz
	tar -xzvf latest.tar.gz
	rm latest.tar.gz
fi
