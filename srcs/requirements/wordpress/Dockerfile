FROM debian:bullseye

ARG WORDPRESS_VERSION=5.8.1

# Update and upgrade the Debian package manager packages
RUN apt-get update \
  && apt-get upgrade -y

# Install wget and gettext
RUN apt-get install -y wget gettext

# Install PHP and related packages
RUN apt-get install -y \
    php php-fpm php-mysqli php-zip php-gd \
    php-mbstring php-cli php-opcache php-zlib \
    php-curl php-json php-iconv php-gettext \
    php-session php-phar mariadb-client php-pdo php-pdo_mysql \
    php-dom php-ctype php-bcmath php-fileinfo php-intl \
    php-mysqlnd php-openssl php-pdo_pgsql php-pdo_sqlite php-posix \
    php-simplexml php-soap php-tokenizer php-xml php-xmlreader \
    php-xmlwriter

# Download the WordPress CLI and add it to the PATH and make executable
RUN wget https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar \
  --output-document=/usr/local/bin/wp \
  && chmod +x /usr/local/bin/wp

# Create the WordPress directories
# Set the permissions of the template config file to be readable, writable, and executable by the owner and readable and writable by others
RUN mkdir -p /run/php /var/www/html/wordpress \
  && chmod -R 755 /var/www/html/wordpress

# Add the "wordpress_server" group and user
RUN groupadd -r wordpress_server \
  && useradd -r -g wordpress_server wordpress_server

# Copy the config file to container root as a template file
COPY ./conf/www.conf /www.conf.tmpl

# Remove the default config file if it exists
RUN rm -f /etc/php/7.4/fpm/pool.d/www.conf

WORKDIR /var/www/html/wordpress

# Download the WordPress core using the CLI
RUN wp core download --allow-root --version=$WORDPRESS_VERSION

# Copy the setup script to the container root
COPY ./tools/script.sh /script.sh

# Set the setup script as executable
RUN chmod +x /script.sh

ENTRYPOINT [ "/script.sh" ]