#!/bin/bash

#-----------------------------
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


    # Install and activate the theme(optional)
    # wp theme install twentytwentyone --activate --allow-root
	# wp theme install twentytwenty --activate --allow-root
	# wp theme install astra --activate --allow-root
	# wp theme install oceanwp --activate --allow-root #this one is cool
	# wp theme install neve --activate --allow-root
	# wp theme install hestia --activate --allow-root #another cool one
	# wp theme install generatepress --activate --allow-root
	wp theme install sydney --activate --allow-root #also cool



	# # Install and activate caching plugin
	# wp plugin install wp-super-cache --activate --allow-root

	# # Install and activate security plugin
	# wp plugin install wordfence --activate --allow-root

	# # Install and activate SEO plugin
	# wp plugin install wordpress-seo --activate --allow-root

	# # Install and activate backup plugin
	# wp plugin install updraftplus --activate --allow-root

	# # Install and activate database optimization plugin
	# wp plugin install wp-optimize --activate --allow-root

	# # Install and activate monitoring tool
	# wp plugin install google-analytics-for-wordpress --activate --allow-root
fi


# # Create the directory for PHP-FPM runtime data
# mkdir -p /run/php
# touch /run/php/php7.4-fpm.pid

# Start PHP-FPM in the foreground
echo "Starting php-fpm7.4 in the foreground[...]"

# /usr/sbin/php-fpm7.4 -F

exec /usr/sbin/php-fpm7.4 --nodaemonize --allow-to-run-as-root


# # docker exec -it mariadb /bin/bash
# # mysql -h mariadb -P 3306 -u mnascime --password
# # SHOW DATABASES; --> USE inception --> SHOW TABLES;
