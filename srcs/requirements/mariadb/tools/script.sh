#!/bin/bash


# CHECK AND FIX (TO FIX)
service mysql start 


echo "CREATE DATABASE IF NOT EXISTS $MARIADB_DB_NAME ;" > db1.sql
echo "CREATE USER IF NOT EXISTS '$MARIADB_USER_NAME'@'%' IDENTIFIED BY '$MARIADB_USER_PASS' ;" >> db1.sql
echo "GRANT ALL PRIVILEGES ON $MARIADB_DB_NAME.* TO '$MARIADB_USER_NAME'@'%' ;" >> db1.sql
echo "ALTER USER 'root'@'localhost' IDENTIFIED BY '12345' ;" >> db1.sql
echo "FLUSH PRIVILEGES;" >> db1.sql

mysql < db1.sql

kill $(cat /var/run/mysqld/mysqld.pid)

mysqld