FROM alpine:3.15.6

WORKDIR /var/lib/mysql/

COPY ./tools/mariadb-server.cnf /etc/my.cnf.d/
COPY ./tools/docker-entrypoint.sh /

# installatiin
RUN apk update && apk add --no-cache \
		openrc perl xz zstd bash mariadb \
		mariadb-client mariadb-server-utils

# config
RUN ln -s /usr/lib/mariadb/plugin/auth_pam_tool_dir \
		/auth_pam_tool_dir \
	&& mkdir -p /run/openrc/ && touch /run/openrc/softlevel \
	&& chmod +x /docker-entrypoint.sh

ENTRYPOINT "/docker-entrypoint.sh"
