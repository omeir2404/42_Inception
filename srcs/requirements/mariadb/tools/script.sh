#!/bin/bash

set -e

# Ensure the mysql user exists
if ! id "mysql" &>/dev/null; then
    useradd -r -s /bin/false mysql
fi

# Start MariaDB server
mysqld_safe &

# Wait for MariaDB to start
sleep 10

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

# Keep the container running by starting the MariaDB server in the foreground
exec mysqld_safe