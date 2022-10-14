#FROM debian:buster
#
#WORKDIR /app/
#
#COPY ./tools/ /app/
#
## Installation
#RUN apt-get update -y \
#    && apt-get install mariadb-server -y
#
## Configuration
#RUN chmod +x mariadb-install.sh
#
#ENTRYPOINT ["/app/mariadb-install.sh"]
#CMD ["mysqld_safe"]
#
FROM alpine:3.15.6

WORKDIR /app

COPY ./tools/mariadb-server.cnf /etc/my.cnf.d/
COPY ./tools/docker-entrypoint.sh /app/
COPY ./tools/test.sql /app/

# installatiin
RUN apk update && apk add --no-cache bash \
		perl xz bzip2 openssl zstd mariadb \
		mariadb-client mariadb-server-utils

# config
RUN ln -s /usr/lib/mariadb/plugin/auth_pam_tool_dir /auth_pam_tool_dir \
	&& chmod +x /app/docker-entrypoint.sh

ENTRYPOINT "/app/docker-entrypoint.sh"
