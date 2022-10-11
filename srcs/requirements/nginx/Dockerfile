FROM alpine:3.15.6

WORKDIR /app

COPY ./tools/ /app/

RUN apk update && apk add nginx \
	&& mkdir -p /etc/ssl/private \
	&& mv ./localhost.key /etc/ssl/private \
	&& mv ./localhost.crt /etc/ssl/certs \
	&& mv ./nginx.conf /etc/nginx/http.d/default.conf

CMD ["nginx", "-g", "daemon off;"]
