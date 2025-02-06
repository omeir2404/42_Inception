FROM debian:oldstable


RUN apt-get update && apt-get upgrade -y && apt-get install -y \
    curl \
    vim \
    mariadb-client \
    redis-tools \
    bash \
    php \
    php-fpm \
    php-json \
    php-mysql \
    php-curl \
    php-dom \
    php-exif \
    php-fileinfo \
    php-igbinary \
    php-imagick \
    php-intl \
    php-mbstring \
    php-xml \
    php-zip
RUN sed -i 's|listen = /run/php/php7.4-fpm.sock|listen = 9000|g' /etc/php/7.4/fpm/pool.d/www.conf

WORKDIR /var/www/html

EXPOSE 9000


RUN curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar
RUN chmod +x wp-cli.phar
RUN mv wp-cli.phar /usr/local/bin/wp


RUN mkdir -p /run/php

COPY script.sh /etc/wp-cli.sh

ENTRYPOINT ["/bin/bash", "/etc/wp-cli.sh"]