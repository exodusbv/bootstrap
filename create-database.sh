#!/bin/bash

echo "This tool creates a new MySQL database and user, and grants the newly created user all privileges on the new database."
echo ""

# Ask for MySQL root password
echo -n "MySQL root password: "
read mysql_root_password
if [ ! -n "$mysql_root_password" ]; then
  echo "MySQL root password must be given. Cannot continue."
  exit 1
fi

# Ask for database name
echo -n "Database name: "
read database_name
if [ ! -n "$database_name" ]; then
  echo "Database name must be given. Cannot continue."
  exit 1
fi

# Ask for database user name
echo -n "User name [$database_name]: "
read user_name
if [ ! -n "$user_name" ]; then
  user_name="$database_name"
fi

# Generate a random password
password=`openssl rand -hex 16`

mysql -u root -p$mysql_root_password -h localhost -e "create user '$user_name'@'localhost' identified by '$password';"
mysql -u root -p$mysql_root_password -h localhost -e "create database $database_name;"
mysql -u root -p$mysql_root_password -h localhost -e "grant all privileges on $database_name.* to '$user_name'@'localhost';"
mysql -u root -p$mysql_root_password -h localhost -e "flush privileges;"

echo ""
echo "Your database user has been created:"
echo "Database name: $database_name"
echo "User name: $user_name"
echo "Password: $password"
echo ""
echo "Make sure to copy the password now, this is the last time you will be able to see it!"
