FROM debian:oldstable


RUN apt-get update

RUN apt-get upgrade -y

RUN apt-get install -y curl

RUN apt-get install -y vim


RUN apt-get install -y mariadb-client

RUN apt-get install -y redis-tools
RUN apt-get install -y bash


RUN apt-get install -y php

RUN apt-get install -y php-fpm # fast cgi for nginx

RUN apt-get install -y php-json # -> Used for communications with other servers and processing data in JSON format.
RUN apt-get install -y php-mysql # -> Connects to MySQL for database interactions. (Install the mysqli)

RUN apt-get install -y php-curl # Performs remote request operations. 
RUN apt-get install -y php-dom  # Used to validate Text Widget content and to automatically configure IIS7+.
RUN apt-get install -y php-exif # (requires php-mbstring) – Works with metadata stored in images. 
RUN apt-get install -y php-fileinfo  #  Used to detect mimetype of file uploads. 

RUN apt-get install -y php-igbinary # Increases performance as a drop in replacement for the standard PHP serializer. 
RUN apt-get install -y php-imagick # Increases performance as a drop in replacement for the standard PHP serializer. 
RUN apt-get install -y php-intl # Enable to perform locale-aware operations including but not limited to formatting, transliteration, encoding conversion, calendar operations, conformant collation, locating text boundaries and working with locale identifiers, timezones and graphemes. 
RUN apt-get install -y php-mbstring # Used to properly handle UTF8 text. 


RUN apt-get install -y php-xml # Used for XML parsing, such as from a third-party site. 
RUN apt-get install -y php-zip #  Used for decompressing Plugins, Themes, and WordPress update packages. 

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