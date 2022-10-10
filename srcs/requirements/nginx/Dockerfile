FROM alpine:3.15.6

WORKDIR /app

COPY ./tools/ /app/

RUN apk update \
    && apk add nginx \
    && mkdir -p /etc/ssl/private \
    && mv /app/localhost.key /etc/ssl/private \
    && mv /app/localhost.crt /etc/ssl/certs \
    && mv /app/index.html /var/www/rafernan.42.fr/ \
    && mv /app/nginx.conf /etc/nginx/http.d/default.conf

CMD ["nginx", "-g", "daemon off;"]
