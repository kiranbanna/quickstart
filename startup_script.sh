#!/bin/bash

sudo apt-get update

sudo apt-get -y install build-essential libssl-dev binutils binutils-dev openssl
sudo apt-get -y install libdb-dev libexpat1-dev automake checkinstall unzip elinks sshpass

sudo apt-get -y install apache2 libapache2-mod-perl2
sudo apt-get -y install libcrypt-ssleay-perl libwww-perl libhtml-parser-perl libwww-mechanize-perl
sudo apt-get -y install php5

sudo a2enmod ssl
sudo a2ensite default-ssl

sudo apt-get -y install php5-gd
sudo apt-get -y install php5-curl
sudo apt-get -y install php5-mysql
sudo apt-get -y install php5-mcrypt
sudo apt-get -y install php5-mysqli
sudo apt-get -y install mysql-client-core-5.6

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

selfip=$1
sqlserver=$2
echo "Grabbed the IP address ($sqlserver) of the SQL Server."

# Try to install OpenCart via command line.
i2=0
sudo php /var/www/html/opencart/install/cli_install.php install --db_hostname $sqlserver --db_username "opencart" --db_password 'anna' --db_database "opencart" --db_driver mysqli --username 'opencart' --password 'anna' --email "anna@f5.com" --http_server "http://f5.aws.quickstart.com/"  || i2=$[$i2+1]

if [ $i2 == 1 ]
then
   echo "We failed to install because anothe webserver beat us to it."
   sleep 30
   # So we will finish what we have to do, and wait to recieve the config files and have our apache2 restarted.
   sudo sed -e 's|/html|/html/opencart|' -i /etc/apache2/sites-available/000-default.conf /etc/apache2/sites-available/default-ssl.conf
   echo "Edited the apache files."
   sudo chmod 777 -R /var/www/html/opencart
   echo "chmod opencart directory."
   #sudo rm -dfr /var/www/html/opencart/install
   echo "Deleted opencart install directory."
   echo "Finished, waiting for our opencart configuration to be updated by the successful server."
else
   # We succeded because we were the first!
   # Everyone else will fail, so we need to push our config to the others and restart their apache2 server.
   sleep 30
   sudo sed -e 's|/html|/html/opencart|' -i /etc/apache2/sites-available/000-default.conf /etc/apache2/sites-available/default-ssl.conf
   echo "Edited the apache files."
   sudo chmod 777 -R /var/www/html/opencart
   echo "chmod opencart directory."
   #sudo rm -dfr /var/www/html/opencart/install
   echo "Deleted opencart install directory."
   sudo service apache2 restart
   echo "Restarted Apache."
   echo "This Apache Web Server is now hosting OpenCart..."
fi
