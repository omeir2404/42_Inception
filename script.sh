#!/bin/bash

echo -e "\e[31m[mariadb:setup.sh] Script Start!\e[0m"

if [ -d "/var/lib/mysql/$MARIADB_DB_NAME" ]; then
    echo -e "\e[31m[mariadb:setup.sh] Database '$MYSQL_DATABASE' exists, running!\e[0m"
else

    # Ensure the mysql user exists
    if ! id "mysql" &>/dev/null; then
        useradd -r -s /bin/false mysql
    fi

    # Ensure the socket directory exists and is writable
    mkdir -p /run/mysqld
    chown -R mysql:mysql /run/mysqld

    # Ensure the data directory exists and is writable
    if [ ! -d /var/lib/mysql ]; then
        mkdir -p /var/lib/mysql
        chown -R mysql:mysql /var/lib/mysql
    fi

    # Remove any existing aria_log_control file to avoid corruption
    if [ -f /var/lib/mysql/aria_log_control ]; then
        echo "Removing existing aria_log_control file."
        rm -f /var/lib/mysql/aria_log_control
    fi

    # Update MariaDB configuration to reduce log verbosity
    if [ -f /etc/my.cnf ]; then
        sed -i '/\[mysqld\]/a log_warnings=1' /etc/my.cnf
    elif [ -f /etc/mysql/my.cnf ]; then
        sed -i '/\[mysqld\]/a log_warnings=1' /etc/mysql/my.cnf
    fi

    Ensure no other MariaDB instances are running
    if pgrep mysqld; then
        echo "Stopping existing MariaDB instance."
        pkill mysqld
        sleep 5
    fi

    # Start MariaDB server with networking disabled for initial setup
    mysqld --user=mysql --datadir=/var/lib/mysql --skip-networking &

    # Wait for MariaDB to start
    sleep 10 # Increased wait time to ensure MariaDB is fully initialized

    # Repair crashed tables
    mysqlcheck --repair --all-databases -u root -p"${MARIADB_ROOT_PASS}"

    # Update MariaDB configuration if the file exists
    if [ -f /etc/my.cnf.d/mariadb-server.cnf ]; then
        sed -i "s/skip-networking/#skip-networking/" /etc/my.cnf.d/mariadb-server.cnf
        sed -i "s/#bind-address=0.0.0.0/bind-address=0.0.0.0/" /etc/my.cnf.d/mariadb-server.cnf
    fi

    # Restart MariaDB server to apply configuration changes
    pkill mysqld
    sleep 5

    # Start MariaDB with networking enabled
    mysqld --user=mysql --datadir=/var/lib/mysql &

    # Wait for MariaDB to start
    # sleep 10  # Increased wait time to ensure MariaDB is fully initialized

    while ! mysqladmin ping -u root --silent; do
        echo "Waiting for MariaDB to start..."
        sleep 2
    done

    # Create SQL script for database and user setup
    cat <<EOF >db1.sql
CREATE DATABASE IF NOT EXISTS ${MARIADB_DB_NAME};
CREATE USER IF NOT EXISTS '${MARIADB_USER_NAME}'@'%' IDENTIFIED BY '${MARIADB_USER_PASS}';
GRANT ALL PRIVILEGES ON ${MARIADB_DB_NAME}.* TO '${MARIADB_USER_NAME}'@'%';
ALTER USER 'root'@'localhost' IDENTIFIED BY '${MARIADB_ROOT_PASS}';
FLUSH PRIVILEGES;
EOF

    # Execute SQL script
    mariadb -u root -p"${MARIADB_ROOT_PASS}" <db1.sql

    # Clean up the SQL script
    rm db1.sql

fi

exec mysqld --user=mysql --datadir=/var/lib/mysql
