#!/bin/bash

set -e

# Ensure the mysql user exists
if ! id "mysql" &>/dev/null; then
    useradd -r -s /bin/false mysql
fi

# Ensure the socket directory exists and is writable
mkdir -p /run/mysqld
chown -R mysql:mysql /run/mysqld

# Ensure the data directory is writable
chown -R mysql:mysql /var/lib/mysql

echo "\n\n\n\n\nchanging permissions for aria_log_control\n\n\n\n\n\n\n\n\n\n\n\\nn\\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\nn\\nn\n\n\n"
# Remove any existing lock files
# rm -f /var/lib/mysql/aria_log_control
chmod 660 /var/lib/mysql/aria_log_control
chown mysql:mysql /var/lib/mysql/aria_log_control

# Update MariaDB configuration to reduce log verbosity
if [ -f /etc/my.cnf ]; then
    sed -i '/\[mysqld\]/a log_warnings=1' /etc/my.cnf
elif [ -f /etc/mysql/my.cnf ]; then
    sed -i '/\[mysqld\]/a log_warnings=1' /etc/mysql/my.cnf
fi

# Start MariaDB server
mysqld --user=mysql --datadir=/var/lib/mysql --skip-networking &

# Wait for MariaDB to start
sleep 5

# Run mysql_upgrade with --force and root password
echo "Running mysql_upgrade"
mysql_upgrade --force -u root -p"${MARIADB_ROOT_PASS}"

# Update MariaDB configuration if the file exists
if [ -f /etc/my.cnf.d/mariadb-server.cnf ]; then
    sed -i "s/skip-networking/#skip-networking/" /etc/my.cnf.d/mariadb-server.cnf
    sed -i "s/#bind-address=0.0.0.0/bind-address=0.0.0.0/" /etc/my.cnf.d/mariadb-server.cnf
fi

# Restart MariaDB server to apply configuration changes
pkill mysqld
sleep 3
mysqld --user=mysql --datadir=/var/lib/mysql &

# Wait for MariaDB to start
sleep 5

# Create SQL script
cat <<EOF > db1.sql
CREATE DATABASE IF NOT EXISTS ${MARIADB_DB_NAME};
CREATE USER IF NOT EXISTS '${MARIADB_USER_NAME}'@'%' IDENTIFIED BY '${MARIADB_USER_PASS}';
GRANT ALL PRIVILEGES ON ${MARIADB_DB_NAME}.* TO '${MARIADB_USER_NAME}'@'%';
ALTER USER 'root'@'localhost' IDENTIFIED BY '${MARIADB_ROOT_PASS}';
FLUSH PRIVILEGES;
EOF

# Execute SQL script
mariadb -u root -p"${MARIADB_ROOT_PASS}" < db1.sql

# Keep the container running by starting the MariaDB server in the foreground
exec mysqld --user=mysql --datadir=/var/lib/mysql   