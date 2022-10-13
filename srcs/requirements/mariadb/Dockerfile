FROM debian:buster

WORKDIR /app/

COPY ./tools/ /app/

# Installation
RUN apt-get update -y \
    && apt-get install mariadb-server -y

# Configuration
RUN chmod +x mariadb-install.sh

ENTRYPOINT /app/mariadb-install.sh
