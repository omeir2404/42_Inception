# #!/bin/bash
# # Downloads the file for wordpress

# dir_path="/var/www/html/oharoon.42.fr/"
# file_name="wp-config.php"

# if ! [ -f "$dir_path$file_name" ]; then

# 	cd /var/www/html
# 	# --silent -> doesn't print anything to the terminal
# 	# -O -> tells curl to save the file as it is named remotely
# 	curl --silent -O https://wordpress.org/latest.tar.gz .

# 	echo "Wordpress files have been downloaded."

# 	# -x -> extract file
# 	# -z -> .gz files
# 	# -f -> path to the file
# 	# Extract file
# 	tar -xzf latest.tar.gz

# 	# Remove .tar.gz
# 	rm latest.tar.gz

# 	# Saves the files in a given directory

# 	mkdir -p oharoon.42.fr

# 	mv wordpress/* oharoon.42.fr

# 	rm -rf wordpress

# 	echo "Wordpress files discompressed and in folder."

# 	cd oharoon.42.fr

# 	sed -i "s/database_name_here/$MARIADB_DB_NAME/g" wp-config-sample.php
# 	sed -i "s/username_here/$MARIADB_USER_NAME/g" wp-config-sample.php
# 	sed -i "s/password_here/$MARIADB_USER_PASS/g" wp-config-sample.php
# 	sed -i "s/localhost/$MARIADB_HOST/g" wp-config-sample.php

# 	mv wp-config-sample.php wp-config.php

# 	# Uses WP-CLI to create a new user
# 	# Link -> https://developer.wordpress.org/cli/commands/user/create/
# 	wp core install --allow-root --url=$URL --title="Inception" \
# 	--admin_user=$WORDPRESS_ADMIN_NAME \
# 	--admin_password=$WORDPRESS_ADMIN_PASS \
# 	--admin_email=$WORDPRESS_ADMIN_EMAIL --skip-email

# 	wp user create --allow-root $WORDPRESS_USER_NAME $WORDPRESS_USER_EMAIL "--user_pass=$WORDPRESS_USER_PASS" --role=author

# 	echo "Add database config inside the wp-config.php. "

# fi

# # Looks for the attr. listen inside the www.conf and changes it our port
# sed -i 's|listen = /run/php/php7.4-fpm.sock|listen = 0.0.0.0:9000|g' /etc/php/7.4/fpm/pool.d/www.conf

# # Creates the folder for php
# mkdir -p /run/php
# # The /run/php directory is a temporary filesystem location used by PHP and its associated processes, like PHP-FPM (FastCGI Process Manager), to store runtime data. Here’s a closer look at its purpose:
# touch /run/php/php7.4-fpm.pid

# echo "Starting php-fpm7.4 in the foreground[...]";

# /usr/sbin/php-fpm7.4 --nodaemonize --allow-to-run-as-root




#-----------------------------
#!/bin/bash

if [ ! -f wp-config.php ];
then
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
fi
/usr/sbin/php-fpm7.4 -F

# docker exec -it mariadb /bin/bash
# mysql -h mariadb -P 3306 -u mnascime --password
# SHOW DATABASES; --> USE inception --> SHOW TABLES;