#!/bin/sh

# Sets the script to run in debug mode, which displays commands and their arguments as they are executed
# set -x

# Check if config file has already been created by a previous run of this script
if [ -e /etc/php/7.4/fpm/pool.d/www.conf ]; then
    echo "FastCGI Process Manager config already created"
else
    # Hydrate configuration template with env variables and create config file
    cat /www.conf.tmpl | envsubst > /etc/php/7.4/fpm/pool.d/www.conf
    echo "FastCGI Process Manager config created"
fi

# Wait for MariaDB to be ready
until mysqladmin ping -h "$MARIADB_HOST" --silent; do
    echo "Waiting for MariaDB to be ready..."
    sleep 5
done

# Check if wp-config.php file has already been created by a previous run
if [ -e /var/www/html/wp-config.php ]; then
    echo "WordPress config already created"
else
    echo "Downloading WordPress core"
    wp core download --allow-root

    echo "Creating WordPress config file"
    wp config create --allow-root \
        --dbname=$MARIADB_DB_NAME \
        --dbuser=$MARIADB_USER_NAME \
        --dbpass=$MARIADB_USER_PASS \
        --dbhost=$MARIADB_HOST \
        --path=/var/www/html
fi

# Check if WordPress is already installed
if wp core is-installed --allow-root; then
    echo "WordPress core already installed"
else    
    echo "Installing WordPress"
    wp core download --allow-root
    sleep 5

    echo "Creating WordPress config file"
    wp config create --allow-root \
       --dbname=$MARIADB_DB_NAME \
       --dbuser=$MARIADB_USER_NAME \
       --dbpass=$MARIADB_USER_PASS \
       --dbhost=$MARIADB_HOST \
       --path=/var/www/html

    echo "Installing WordPress core"
    wp core install --allow-root \
        --url=$WORDPRESS_URL \
        --title=$WORDPRESS_TITLE \
        --admin_user=$WORDPRESS_ADMIN_NAME \
        --admin_email=$WORDPRESS_ADMIN_EMAIL \
        --admin_password=$WORDPRESS_ADMIN_PASS \
        --path=/var/www/html

    echo "Creating a new author user"
    wp user create --allow-root \
        $WORDPRESS_USER_NAME \
        $WORDPRESS_USER_EMAIL \
        --role=author \
        --user_pass=$WORDPRESS_USER_PASS \
        --path=/var/www/html

    # Set the debugging mode of WordPress to false
    # wp config set WORDPRESS_DEBUG false --allow-root --path=/var/www/html
fi

# Start the php-fpm process with the exec command, passing any additional arguments ($@)
echo "Starting FastCGI Process Manager"
exec php-fpm7.4 --nodaemonize