FROM alpine:3.15.6

WORKDIR /var/www/rafernan.42.fr/

COPY ./tools/ /

# Installation
RUN apk update \
	&& apk add  --no-cache bash php8 php8-fpm mysql-client \
				php8-phar php8-iconv php8-opcache php8-gd \
				php8-mysqli php8-zlib php8-curl \
	&& ln -s /usr/bin/php8 /usr/bin/php

# Configuration
RUN sed 's/listen = 127.0.0.1:9000/listen = 9000/g' \
		-i /etc/php8/php-fpm.d/www.conf \
	&& wget https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar \
	-O /usr/bin/wp && chmod +x /usr/bin/wp \
	&& chmod +x /docker-entrypoint.sh

ENTRYPOINT "/docker-entrypoint.sh"
