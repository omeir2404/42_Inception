FROM debian:bullseye

ARG WORDPRESS_VERSION=5.8.1
# Update the Debian repository information:
  RUN apt-get update

  # Update apt-get for protection againts vulnerabilities:
  RUN apt-get upgrade -y
  
  # Installs curl in the system
  RUN apt-get install -y curl
  
  RUN apt-get install -y vim
  
  
  #Installing for DEBUG purpose
  RUN apt-get install -y mariadb-client
  
  #Installing for DEBUG purpose
  RUN apt-get install -y redis-tools
  #redis-cli -h redis -p 6379 ping
  #redis-cli -h redis -p 6379 SET my_key
  #redis-cli -h redis -p 6379 GET my_key
  
  #Bash is not nativaly installed
  RUN apt-get install -y bash
  
  # List of the php extension recommend for the last version of wordpress
  # List -> https://make.wordpress.org/hosting/2024/07/10/wordpress-6-6-server-compatibility/
  # List -> https://zermysql -h mariadb -P 3306 -u root -p$MYSQL_ROOT_PASSWORD
  # opointdevelopment.com/required-php-extensions-for-wordpress-wpquickies/
  # List -> https://wordpress.com/support/php-environment/
  
  RUN apt-get install -y php
  
  RUN apt-get install -y php-fpm # fast cgi for nginx
  
  # !!! Very important
  # This is the actual list
  # -> https://make.wordpress.org/hosting/handbook/server-environment/#php-extensions
  
  
  # The PHP extensions listed below are required for a WordPress site to work.
  RUN apt-get install -y php-json # -> Used for communications with other servers and processing data in JSON format.
  RUN apt-get install -y php-mysql # -> Connects to MySQL for database interactions. (Install the mysqli)
  
  # The PHP extensions listed below are highly recommended in order to allow WordPress to operate optimally and to maximise compatibility with many popular plugins and themes.
  
  RUN apt-get install -y php-curl # Performs remote request operations. 
  RUN apt-get install -y php-dom  # Used to validate Text Widget content and to automatically configure IIS7+.
  RUN apt-get install -y php-exif # (requires php-mbstring) – Works with metadata stored in images. 
  RUN apt-get install -y php-fileinfo  #  Used to detect mimetype of file uploads. 
  
  # Comes in the php core
  #RUN apt-get install -y php-hash # Used for hashing, including passwords and update packages.
  
  RUN apt-get install -y php-igbinary # Increases performance as a drop in replacement for the standard PHP serializer. 
  RUN apt-get install -y php-imagick # Increases performance as a drop in replacement for the standard PHP serializer. 
  RUN apt-get install -y php-intl # Enable to perform locale-aware operations including but not limited to formatting, transliteration, encoding conversion, calendar operations, conformant collation, locating text boundaries and working with locale identifiers, timezones and graphemes. 
  RUN apt-get install -y php-mbstring # Used to properly handle UTF8 text. 
  
  
  # This packages doesn't exists
  #RUN apt-get install -y php-openssl # SSL-based connections to other hosts. 
  
  #RUN apt-get install -y php-pcre # Increases performance of pattern matching in code searches. 
  
  
  RUN apt-get install -y php-xml # Used for XML parsing, such as from a third-party site. 
  RUN apt-get install -y php-zip #  Used for decompressing Plugins, Themes, and WordPress update packages. 
  
  
  #Install PHP-CLI
  # Link -> https://make.wordpress.org/cli/handbook/guides/installing/
  
  RUN curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar
  RUN chmod +x wp-cli.phar
  RUN mv wp-cli.phar /usr/local/bin/wp
  
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