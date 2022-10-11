FROM alpine:3.15.6

WORKDIR /var/www/rafernan.42.fr/

COPY ./tools/ /app

RUN apk update \
	&& apk add	bash openrc php8 \
				php8-fpm php8-opcache php8-gd \
				php8-mysqli php8-zlib php8-curl \
	&& rc-update add php-fpm8 default \
	&& sed 's/listen = 127.0.0.1:9000/listen = 9000/g' -i /etc/php8/php-fpm.d/www.conf \
	&& mkdir /run/openrc && touch /run/openrc/softlevel \
	&& echo 'rc_provide="loopback net"' >> /etc/rc.conf \
	&& rc-status -a && rc-service php-fpm8 restart \
	&& chmod +x /app/wp-install.sh && /app/wp-install.sh

CMD ["php-fpm8", "-F", "-R"]
