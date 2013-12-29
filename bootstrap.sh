#!/bin/bash

# Ask for deploy user name
read -s "Deploy user name [deploy]: " username
deploy_user=${$username:-deploy}

# Ask for MySQL root password
read -p -s "MySQL root password: " mysql_root_password
if [ ! -n "$mysql_root_password" ]; then
  echo "MySQL root password must be given. Cannot continue."
  exit 1
fi

if [ ! -d /home/$deploy_user ]; then
  # Add deploy user
  sudo adduser --disabled-password --gecos "" $deploy_user
fi

# Add deploy to sudoers
sudo sh -c "echo '$deploy_User ALL=(ALL) NOPASSWD:ALL' > /etc/sudoers.d/99-$deploy_user"

# Add public key file
sudo su $deploy_user -c "curl -s ssh.keychain.io/mail@marceldegraaf.net/install | bash"

# Install Ruby
sudo apt-add-repository ppa:brightbox/ruby-ng
sudo apt-get update
sudo apt-get install -y ruby1.9.1

# Install bundler
sudo gem install bundler --no-ri --no-rdoc --update

# Set MySQL root password
sudo debconf-set-selections <<< "mysql-server mysql-server/root_password password $mysql_root_password"
sudo debconf-set-selections <<< "mysql-server mysql-server/root_password_again password $mysql_root_password"

# Install support software
sudo apt-get install -y build-essential vim imagemagick wget git-core htop libmagickwand-dev libcurl4-openssl-dev libpcre3-dev ruby-dev libssl0.9.8 libmysql-ruby libmysqlclient-dev nodejs mysql-server

# Install Passenger
sudo gem install passenger --no-ri --no-rdoc --update

# Create application dirs
sudo mkdir -p /apps

# Give deploy user access to application dirs
sudo chown $deploy_user: /apps

# Install nginx init script and config file
sudo mkdir -p /etc/init.d
sudo mkdir -p /etc/nginx
sudo su -c "curl -s https://raw.github.com/exodusbv/bootstrap/master/files/nginx.init.sh > /etc/init.d/nginx"
sudo su -c "curl -s https://raw.github.com/exodusbv/bootstrap/master/files/nginx.conf > /etc/nginx/nginx.conf"
sudo chmod +x /etc/init.d/nginx

# Install create-database script
sudo su -c "curl -s https://raw.github.com/exodusbv/bootstrap/master/create-database.sh > /usr/bin/create-database"
sudo chmod go+rx /usr/bin/create-database

# Install Passenger/Nginx module
sudo su -c "passenger-install-nginx-module --auto --auto-download"

# Done!
echo "Done! This server is now ready to host Ruby/Rails apps."
