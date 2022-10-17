FROM alpine:3.15.6

WORKDIR /app

COPY ./tools/localhost.key /etc/ssl/private/
COPY ./tools/localhost.crt /etc/ssl/certs/
COPY ./tools/nginx.conf /etc/nginx/http.d/default.conf

# installation
RUN apk update && apk add --no-cache bash nginx

CMD ["nginx", "-g", "daemon off;"]
