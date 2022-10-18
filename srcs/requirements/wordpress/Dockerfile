FROM alpine:3.15.6

WORKDIR /var/www/rafernan.42.fr/

COPY ./tools/docker-entrypoint.sh /

# Installation
RUN apk update \
	&& apk add  --no-cache bash mysql-client netcat-openbsd \
				php8 php8-fpm php8-session php8-gd \
				php8-phar php8-iconv php8-opcache \
				php8-mysqli php8-zlib php8-curl \
	&& ln -s /usr/bin/php8 /usr/bin/php

# Configuration
RUN sed 's/listen = 127.0.0.1:9000/listen = 9000/g' \
		-i /etc/php8/php-fpm.d/www.conf \
	# wordpress cli
	&& wget https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar \
		-O /usr/bin/wp && chmod +x /usr/bin/wp \
	&& mkdir -p ./adminer/ \
	# adminer
	&& wget "https://github.com/vrana/adminer/releases/download/v4.8.1/adminer-4.8.1.php" \
		-O ./adminer/index.php \
	&& chmod +x /docker-entrypoint.sh \
	# wordpress files
	&& wp core download

ENTRYPOINT "/docker-entrypoint.sh"
