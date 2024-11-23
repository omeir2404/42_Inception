#!/bin/bash

echo -e "\e[31m[mariadb:setup.sh] Script Start!\e[0m"

# Ensure the socket directory exists and is writable
mkdir -p /run/mysqld
chown -R mysql:mysql /run/mysqld

# Ensure the data directory is writable
chown -R mysql:mysql /var/lib/mysql

if ! [ -d "/var/lib/mysql/$MARIADB_DB_NAME" ]; then
    service mariadb start
    while ! mysqladmin ping -u root --silent ; do
        echo -e "\e[31mWaiting for MariaDB to start...\e[0m"
        sleep 2
    done

    # It has to be spaces for the indentation of the queries
    mysql --socket=/run/mysqld/mysqld.sock --host=localhost -uroot -e "
        USE mysql;
        ALTER USER 'root'@'localhost' IDENTIFIED BY '$MARIADB_ROOT_PASS';
        FLUSH PRIVILEGES;
        CREATE DATABASE IF NOT EXISTS $MARIADB_DB_NAME;
        CREATE USER IF NOT EXISTS '$MARIADB_USER_NAME'@'%' IDENTIFIED BY '$MARIADB_USER_PASS';
        GRANT ALL PRIVILEGES ON $MARIADB_DB_NAME.* TO '$MARIADB_USER_NAME'@'%';
        FLUSH PRIVILEGES;
    " > /dev/null

    # $? holds the status value of the last executed code
    # -eq (operator that means equal)
    if [ $? -eq 0 ]; then
        echo -e "\e[31mMySQL setup completed successfully:\e[0m"
    else
        echo -e "\e[31mMySQL setup failed:\e[0m"
    fi
    echo -e "\e[31mmysql --socket=/run/mysqld/mysqld.sock --host=localhost -uroot -p'$MARIADB_ROOT_PASS' -e '...queries...'\e[0m"

else
   echo -e "\e[31mDatabase has already been created.\e[0m"
fi

echo -e "\e[31mMariaDB is running in the foreground[...]\e[0m"

exec mysqld_safe --bind-address=0.0.0.0 --port=3306