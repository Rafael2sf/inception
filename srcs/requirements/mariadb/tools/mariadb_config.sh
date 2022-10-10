#!/bin/bash

# Start mysql
/etc/init.d/mysql start

# Allow remote connection from any ip
sed 's/127.0.0.1/0.0.0.0/g' -i /etc/mysql/mariadb.conf.d/50-server.cnf

# Database configuration
mysql -u root -e "CREATE USER 'user'@'%' IDENTIFIED BY 'user'"
mysql -u root -e "GRANT ALL PRIVILEGES ON *.* TO 'user'@'%' IDENTIFIED BY 'user'"
mysql -u root -e "CREATE DATABASE test_db"
mysql -u root -e "DROP USER ''@'localhost'"
mysql -u root -e "DROP USER ''@'$(hostname)'"
mysql -u root -e "DROP DATABASE test"
mysql -u root -e "FLUSH PRIVILEGES"

# Set root password
mysqladmin -u root password 'root'
