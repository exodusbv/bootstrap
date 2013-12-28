#!/bin/bash

# Add deploy user
sudo adduser deploy

# Add deploy to sudoers
sudo sh -c "echo 'deploy ALL=(ALL) NOPASSWD:ALL' > /etc/sudoers.d/99-deploy"

# Add public key file
sudo su deploy -c "curl -s ssh.keychain.io/mail@marceldegraaf.net/install | bash"

# Install Ruby
sudo apt-add-repository ppa:brightbox/ruby-ng
sudo apt-get update
sudo apt-get install -y ruby1.9.1

# Install bundler
sudo gem install bundler

# Install support software
sudo apt-get install -y build-essential vim imagemagick wget git-core htop libmagickwand-dev libcurl4-openssl-dev libpcre3-dev ruby-dev libssl0.9.8 libmysql-ruby libmysqlclient-dev nodejs mysql-server

# Install Passenger
sudo gem install passenger

# Install Passenger/Nginx module
sudo passenger-install-nginx-module

# Create application dirs
sudo mkdir /apps

# Give deploy user access to application dirs
sudo chown deploy: /apps

# Install nginx init script and config file
mkdir -p /etc/init.d
mkdir -p /etc/nginx
sudo su -c "curl -s https://raw.github.com/exodusbv/bootstrap/master/files/nginx.init.sh > /etc/init.d/nginx"
sudo su -c "curl -s https://raw.github.com/exodusbv/bootstrap/master/files/nginx.conf > /etc/nginx/nginx.conf"
