
#!/bin/bash

mkdir -p /run/mysqld
chown -R mysql:mysql /run/mysqld

if ! [ -d "$MARIADB_DB_NAME"  ]; 
then
	service mariadb start

	mariadb -u root -e "
	CREATE DATABASE IF NOT EXISTS $MARIADB_DB_NAME;
	CREATE USER IF NOT EXISTS '$MARIADB_USER_NAME'@'%' IDENTIFIED BY '$MARIADB_USER_PASS';
	GRANT ALL PRIVILEGES ON $MARIADB_DB_NAME.* TO '$MARIADB_USER_NAME'@'%';
	ALTER USER 'root'@'localhost' IDENTIFIED BY '$MARIADB_ROOT_PASS';
	FLUSH PRIVILEGES;
	SHUTDOWN;"
fi
mysqld_safe --bind-address=0.0.0.0 --port=3306
