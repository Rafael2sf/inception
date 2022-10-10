FROM alpine:3.15.6

RUN apk update \
	&& apk add	bash openrc php8 \
				php8-fpm php8-opcache php8-gd \
				php8-mysqli php8-zlib php8-curl

CMD ["tail", "-f", "/dev/null"]
