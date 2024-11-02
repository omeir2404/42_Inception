#!/bin/sh

# Sets the script to run in debug mode, which displays commands and their arguments as they are executed
set -x

# Check if config file has already been created by a previous run of this script
if [ -e /etc/php/7.4/fpm/pool.d/www.conf ]; then
    echo "FastCGI Process Manager config already created"
else
    # Hydrate configuration template with env variables and create config file
    cat /www.conf.tmpl | envsubst > /etc/php/7.4/fpm/pool.d/www.conf
fi

# Check if wp-config.php file has already been created by a previous run
if [ -e /var/www/html/wordpress/wp-config.php ]; then
    echo "WordPress config already created"
else
    # Create the WordPress config file using environment variables
    wp config create --allow-root \
        --dbname=$WORDPRESS_DB_NAME \
        --dbuser=$MARIADB_USER_NAME \
        --dbpass=$MARIADB_USER_PASS \
        --dbhost=$MARIADB_HOST \
        --path=/var/www/html/wordpress

    # Create the WordPress database using the config file created above
    wp db create --allow-root --path=/var/www/html/wordpress
fi

# Check if WordPress is already installed
if wp core is-installed --allow-root --path=/var/www/html/wordpress; then
    echo "WordPress core already installed"
else
    # Install WordPress with environment variables
    wp core install --allow-root \
        --url=$WORDPRESS_URL \
        --title=$WORDPRESS_TITLE \
        --admin_user=$WORDPRESS_ADMIN_NAME \
        --admin_email=$WORDPRESS_ADMIN_EMAIL \
        --admin_password=$WORDPRESS_ADMIN_PASS \
        --path=/var/www/html/wordpress

    # Create a new author user
    wp user create --allow-root \
        $WORDPRESS_USER_NAME \
        $WORDPRESS_USER_EMAIL \
        --role=author \
        --user_pass=$WORDPRESS_USER_PASS \
        --path=/var/www/html/wordpress

    # Set the debugging mode of WordPress to false which will turn off debugging messages, error reporting, and logging. Needed when using CLI from container
    wp config set WORDPRESS_DEBUG false --allow-root --path=/var/www/html/wordpress
fi

# Update all plugins
wp plugin update --all --allow-root --path=/var/www/html/wordpress

# Start the php-fpm process with the exec command, passing any additional arguments ($@)
echo "Start FastCGI Process Manager"
exec php-fpm7.4 --nodaemonize