#!/bin/bash

set -e

# Start MariaDB service
service mysql start 

# Create SQL script
cat <<EOF > db1.sql
CREATE DATABASE IF NOT EXISTS ${MARIADB_DB_NAME};
CREATE USER IF NOT EXISTS '${MARIADB_USER_NAME}'@'%' IDENTIFIED BY '${MARIADB_USER_PASS}';
GRANT ALL PRIVILEGES ON ${MARIADB_DB_NAME}.* TO '${MARIADB_USER_NAME}'@'%';
ALTER USER 'root'@'localhost' IDENTIFIED BY '${MARIADB_ROOT_PASS}';
FLUSH PRIVILEGES;
EOF

# Execute SQL script
mariadb < db1.sql

# Stop MariaDB service
kill $(cat /var/run/mysqld/mysqld.pid)

# Start MariaDB server
exec mysqld