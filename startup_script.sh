#!/bin/bash
sudo apt-get update

sudo apt-get -y install build-essential libssl-dev binutils binutils-dev openssl
sudo apt-get -y install libdb-dev libexpat1-dev automake checkinstall unzip elinks sshpass
sudo apt-get -y install curl wget lynx w3m

sudo apt-get -y install apache2 libapache2-mod-perl2
sudo apt-get -y install libcrypt-ssleay-perl libwww-perl libhtml-parser-perl libwww-mechanize-perl
sudo apt-get -y install php5

sudo a2enmod ssl
sudo a2ensite default-ssl

sudo apt-get -y install mysql-client-core-5.6
sudo apt-get -y install php5-gd
sudo apt-get -y install php5-curl
sudo apt-get -y install php5-mysql
sudo apt-get -y install php5-mcrypt

sudo apt-get -y install mysql-client-core-5.5
sudo apt-get -y install mariadb-client-core-5.5
sudo apt-get -y install mysql-client-core-5.6
sudo apt-get -y install percona-xtradb-cluster-client-5.5

sudo php5enmod mcrypt
sudo service apache2 restart

sudo unzip ./opencart-3.0.2.0.zip -d opencart
echo "Finished inflating zip file."

sudo chmod 777 -R /var/www/html
sudo mkdir /var/www/html/opencart
sudo chmod 777 -R /var/www/html/opencart

sudo mv opencart/upload/* /var/www/html/opencart/.
sudo mv /var/www/html/opencart/config-dist.php /var/www/html/opencart/config.php
sudo mv /var/www/html/opencart/admin/config-dist.php /var/www/html/opencart/admin/config.php
sudo echo "Moved config files."

echo "SQL server is now alive."

sqlserver=$1
url=$2
echo "Grabbed the IP address ($sqlserver) of the SQL Server."

# Try to install OpenCart via command line.
i2=0
sudo php /var/www/html/opencart/install/cli_install.php install --db_hostname $sqlserver --db_username "opencart" --db_password "anna" --db_database "opencart" --db_driver mysqli --db_port 3306 --username "opencart" --password 'anna' --email "anna@f5.com" --http_server "$2" || i2=$[$i2+1]

# We succeded because we were the first!
# Everyone else will fail, so we need to push our config to the others and restart their apache2 server.
sleep 10
sudo sed -e 's|/html|/html/opencart|' -i /etc/apache2/sites-available/000-default.conf /etc/apache2/sites-available/default-ssl.conf
sudo service apache2 restart
sudo rm -dfr /var/www/html/opencart/install
echo "Restarted Apache."
