FROM debian:bullseye

ARG WORDPRESS_VERSION=5.8.1

# Update the Debian repository information
RUN apt-get update

# Update apt-get for protection against vulnerabilities
RUN apt-get upgrade -y

# Install necessary packages
RUN apt-get install -y curl vim mariadb-client redis-tools bash

# Install PHP and required extensions
RUN apt-get install -y php php-fpm php-json php-mysql php-curl php-dom php-exif php-fileinfo php-igbinary php-imagick php-intl php-mbstring php-xml php-zip

# Download the WordPress CLI and add it to the PATH and make executable
RUN curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar \
  && chmod +x wp-cli.phar \
  && mv wp-cli.phar /usr/local/bin/wp

# Create the WordPress directories
# Set the permissions of the template config file to be readable, writable, and executable by the owner and readable and writable by others
RUN mkdir -p /run/php /var/www/html \
  && chmod -R 755 /var/www/html

# Add the "wordpress_server" group and user
RUN groupadd -r wordpress_server \
  && useradd -r -g wordpress_server wordpress_server

# Copy the config file to container root as a template file
COPY ./conf/www.conf /www.conf.tmpl

# Remove the default config file if it exists
RUN rm -f /etc/php/7.4/fpm/pool.d/www.conf

WORKDIR /var/www/html

# Copy the setup script to the container root
COPY ./tools/script.sh /script.sh

# Set the setup script as executable
RUN chmod +x /script.sh

ENTRYPOINT [ "sh", "/script.sh" ]