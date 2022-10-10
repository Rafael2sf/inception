FROM debian:buster

WORKDIR /app

COPY ./tools/ /app/

RUN apt-get update -y \
    && apt-get install mariadb-server -y \
    && mysql_install_db \
    && chmod +x ./mariadb_config.sh && ./mariadb_config.sh

CMD ["mysqld_safe"]
