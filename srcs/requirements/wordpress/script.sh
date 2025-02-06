#!/bin/bash

if [ ! -f wp-config.php ]; then

	wp core download --allow-root

	wp config create --allow-root \
					 --dbname=$WORDPRESS_DB_NAME \
					 --dbuser=$MARIADB_USER_NAME \
					 --dbpass=$MARIADB_USER_PASS \
					 --dbhost=mariadb

	wp core install  --allow-root \
					 --skip-email \
					 --title="inception" \
					 --url=$WORDPRESS_ADMIN_URL \
					 --admin_user=$WORDPRESS_ADMIN_NAME \
					 --admin_password=$WORDPRESS_ADMIN_PASS \
					 --admin_email=$WORDPRESS_ADMIN_EMAIL

	wp user create   --allow-root $WORDPRESS_USER_NAME $WORDPRESS_USER_EMAIL \
					 --user_pass=$WORDPRESS_USER_PASS

	wp theme install sydney --activate --allow-root

fi

echo "Starting php-fpm7.4 in the foreground[...]"


exec /usr/sbin/php-fpm7.4 --nodaemonize --allow-to-run-as-root
