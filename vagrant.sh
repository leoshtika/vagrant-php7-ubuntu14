#!/usr/bin/env bash

# Add repository for PHP 7.2
add-apt-repository ppa:ondrej/php

# Update the list of available packages
apt-get -y update

# Install GIT
apt-get install -y git

# Installing Apache
apt-get install -y apache2

# Remove 'html' folder and add a symbolic link, only if it doesn't already exists
if ! [ -L /var/www/html ]; then
  rm -rf /var/www/html
  ln -fs /vagrant /var/www/html
fi

# Change AllowOverride in apache2.conf for the .htaccess to work
sed -i '/<Directory \/var\/www\/>/,/<\/Directory>/ s/AllowOverride None/AllowOverride All/' /etc/apache2/apache2.conf
# Enable Apache's mod_rewrite
sudo a2enmod rewrite

# Installing PHP and it's dependencies
apt-get install -y php7.2 php7.2-curl php7.2-gd php7.2-mbstring php7.2-zip php7.2-xml

# Configure PHP
sed -i s/'display_errors = Off'/'display_errors = On'/ /etc/php/7.2/apache2/php.ini

# Install Composer
if [ ! -f /usr/local/bin/composer ]; then
    curl -sS https://getcomposer.org/installer | php
    mv composer.phar /usr/local/bin/composer
fi

# Restart Apache
service apache2 restart

echo "============================================"
echo "Your development environment with PHP 7.2 is ready"
echo "URL: http://localhost:4000"
echo "Synced folder: 'vagrant ssh' & 'cd /vagrant'"
echo "============================================"