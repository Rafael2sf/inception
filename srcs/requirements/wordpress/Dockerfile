FROM alpine:3.15.6

WORKDIR /var/www/rafernan.42.fr/

COPY ./tools/ /

# Installation
RUN apk update \
	&& apk add  --no-cache bash \
				php8-fpm php8-opcache php8-gd \
				php8-mysqli php8-zlib php8-curl

# Configuration
RUN sed 's/listen = 127.0.0.1:9000/listen = 9000/g' \
		-i /etc/php8/php-fpm.d/www.conf \
	&& chmod +x /docker-entrypoint.sh

ENTRYPOINT "/docker-entrypoint.sh"
