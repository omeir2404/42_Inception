# #!/bin/bash

# echo -e "\e[31m[mariadb:setup.sh] Script Start!\e[0m"

# # Debug: Print environment variables
# echo -e "\e[31mMARIADB_ROOT_PASS: $MARIADB_ROOT_PASS\e[0m"
# echo -e "\e[31mMARIADB_DB_NAME: $MARIADB_DB_NAME\e[0m"
# echo -e "\e[31mMARIADB_USER_NAME: $MARIADB_USER_NAME\e[0m"
# echo -e "\e[31mMARIADB_USER_PASS: $MARIADB_USER_PASS\e[0m"

# # Ensure the required environment variables are set
# if [ -z "$MARIADB_ROOT_PASS" ] || [ -z "$MARIADB_DB_NAME" ] || [ -z "$MARIADB_USER_NAME" ] || [ -z "$MARIADB_USER_PASS" ]; then
#     echo -e "\e[31mError: Required environment variables are not set.\e[0m"
#     exit 1
# fi

# # Ensure the socket directory exists and is writable
# mkdir -p /run/mysqld
# chown -R mysql:mysql /run/mysqld

# # Ensure the data directory is writable
# chown -R mysql:mysql /var/lib/mysql

# if ! [ -d "/var/lib/mysql/$MARIADB_DB_NAME" ]; then
#     service mariadb start
#     while ! mysqladmin ping --silent ; do
#         echo -e "\\e[31mWaiting for MariaDB to start...\\e[0m"
#         sleep 2
#     done

#     # Temporarily start MariaDB in skip-grant-tables mode to reset root password
#     pkill -f mysqld_safe
#     mysqld_safe --skip-grant-tables --skip-networking &
#     sleep 5

#     # Reset root password
#     mysql --socket=/run/mysqld/mysqld.sock --host=localhost -u root -e "
#         FLUSH PRIVILEGES;
#         ALTER USER 'root'@'localhost' IDENTIFIED BY '$MARIADB_ROOT_PASS';
#     "
#     pkill -f mysqld_safe
#     service mariadb start


#     while ! mysqladmin ping -u root --silent ; do
#         echo -e "\e[31mWaiting for MariaDB to start...\e[0m"
#         sleep 2
#     done

#     # It has to be spaces for the indentation of the queries
#     mysql --socket=/run/mysqld/mysqld.sock --host=localhost -uroot -p"$MARIADB_ROOT_PASS" -e "
#         USE mysql;
#         ALTER USER 'root'@'localhost' IDENTIFIED BY '$MARIADB_ROOT_PASS';
#         FLUSH PRIVILEGES;
#         CREATE DATABASE IF NOT EXISTS $MARIADB_DB_NAME;
#         CREATE USER IF NOT EXISTS '$MARIADB_USER_NAME'@'%' IDENTIFIED BY '$MARIADB_USER_PASS';
#         GRANT ALL PRIVILEGES ON $MARIADB_DB_NAME.* TO '$MARIADB_USER_NAME'@'%';
#         FLUSH PRIVILEGES;
#     " > /dev/null

#     if [ $? -eq 0 ]; then
#         echo -e "\e[31mMySQL setup completed successfully:\e[0m"
#     else
#         echo -e "\e[31mMySQL setup failed:\e[0m"
#     fi
#     echo -e "\e[31mmysql --socket=/run/mysqld/mysqld.sock --host=localhost -uroot -p'$MARIADB_ROOT_PASS' -e '...queries...'\e[0m"

# else
#    echo -e "\e[31mDatabase has already been created.\e[0m"
# fi

# echo -e "\e[31mMariaDB is running in the foreground[...]\e[0m"

# # Check if mysqld is already running
# if ! pgrep -x "mysqld" > /dev/null
# then
#     exec mysqld_safe --bind-address=0.0.0.0 --port=3306
# else
#     echo -e "\e[31mMariaDB is already running.\e[0m"
# fi




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
