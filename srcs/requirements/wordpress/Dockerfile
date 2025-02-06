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

    #explanation
    # RUN apt-get update && apt-get upgrade -y && apt-get install -y \
    # curl \ # Command line tool for transferring data with URLs
    # vim \ # Text editor
    # mariadb-client \ # MariaDB client for interacting with MariaDB databases
    # redis-tools \ # Redis command line tools
    # bash \ # Bourne Again SHell
    # php \ # PHP scripting language
    # php-fpm \ # FastCGI Process Manager for PHP
    # php-json \ # Used for communications with other servers and processing data in JSON format
    # php-mysql \ # Connects to MySQL for database interactions (mysqli)
    # php-curl \ # Performs remote request operations
    # php-dom \ # Used to validate Text Widget content and to automatically configure IIS7+
    # php-exif \ # Works with metadata stored in images (requires php-mbstring)
    # php-fileinfo \ # Used to detect mimetype of file uploads
    # php-igbinary \ # Increases performance as a drop-in replacement for the standard PHP serializer
    # php-imagick \ # Provides image processing capabilities
    # php-intl \ # Enables locale-aware operations, including formatting, transliteration, and more
    # php-mbstring \ # Used to properly handle UTF8 text
    # php-xml \ # Used for XML parsing, such as from a third-party site
    # php-zip # Used for decompressing Plugins, Themes, and WordPress update packages

# RUN apt-get -y update && apt-get -y upgrade && apt-get install -y curl php-fpm php-mysql # simple install

RUN sed -i 's|listen = /run/php/php7.4-fpm.sock|listen = 9000|g' /etc/php/7.4/fpm/pool.d/www.conf

WORKDIR /var/www/html

EXPOSE 9000


RUN curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar
RUN chmod +x wp-cli.phar
RUN mv wp-cli.phar /usr/local/bin/wp


RUN mkdir -p /run/php

COPY script.sh /etc/wp-cli.sh

ENTRYPOINT ["/bin/bash", "/etc/wp-cli.sh"]