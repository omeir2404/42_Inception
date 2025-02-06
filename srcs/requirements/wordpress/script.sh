#!/bin/bash

# Define the directory and file name
	# dir_path="/var/www/html/oharoon.42.fr/"
	# file_name="wp-config.php"

# # Check if wp-config.php does not exist
# if [ ! -f "$dir_path$file_name" ]; then
#     cd /var/www/html

#     # Download the latest WordPress files
#     curl --silent -O https://wordpress.org/latest.tar.gz

#     # Extract the downloaded tar.gz file
#     tar -xzf latest.tar.gz

#     # Remove the tar.gz file
#     rm latest.tar.gz

#     # Create the directory for the domain and move WordPress files
#     mkdir -p oharoon.42.fr
#     mv wordpress/* oharoon.42.fr
#     rm -rf wordpress

#     # Change to the domain directory
#     cd oharoon.42.fr

#     # Configure wp-config.php
#     cp wp-config-sample.php wp-config.php
#     sed -i "s/database_name_here/$MARIADB_DB_NAME/g" wp-config.php
#     sed -i "s/username_here/$MARIADB_USER_NAME/g" wp-config.php
#     sed -i "s/password_here/$MARIADB_USER_PASS/g" wp-config.php
#     sed -i "s/localhost/$MARIADB_HOST/g" wp-config.php

#     # Install WordPress using WP-CLI
#     wp core install --allow-root --url=$WORDPRESS_URL --title="Inception" \
#     --admin_user=$WORDPRESS_ADMIN_NAME --admin_password=$WORDPRESS_ADMIN_PASS \
#     --admin_email=$WORDPRESS_ADMIN_EMAIL --skip-email

#     # Create a new WordPress user using WP-CLI
#     wp user create --allow-root $WORDPRESS_USER_NAME $WORDPRESS_USER_EMAIL --user_pass=$WORDPRESS_USER_PASS --role=author
# fi

# # Create the directory for PHP-FPM runtime data
# mkdir -p /run/php
# touch /run/php/php7.4-fpm.pid

# # Start PHP-FPM in the foreground
# exec /usr/sbin/php-fpm7.4 --nodaemonize --allow-to-run-as-root



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
	wp theme install astra --activate --allow-root
	# wp theme install oceanwp --activate --allow-root
	# wp theme install neve --activate --allow-root
	# wp theme install hestia --activate --allow-root
	# wp theme install generatepress --activate --allow-root
	# wp theme install sydney --activate --allow-root
fi


# # Create the directory for PHP-FPM runtime data
# mkdir -p /run/php
# touch /run/php/php7.4-fpm.pid

# Start PHP-FPM in the foreground
echo "Starting php-fpm7.4 in the foreground[...]"

/usr/sbin/php-fpm7.4 -F

# exec /usr/sbin/php-fpm7.4 --nodaemonize --allow-to-run-as-root


# # docker exec -it mariadb /bin/bash
# # mysql -h mariadb -P 3306 -u mnascime --password
# # SHOW DATABASES; --> USE inception --> SHOW TABLES;
