#!/bin/bash
###########################################################################
##       ffff55555                                                       ##
##     ffffffff555555                                                    ##
##   fff      f5    55         Deployment Script Version 0.0.1           ##
##  ff    fffff     555                                                  ##
##  ff    fffff f555555                                                  ##
## fff       f  f5555555             Written By: EIS Consulting          ##
## f        ff  f5555555                                                 ##
## fff   ffff       f555             Date Created: 11/23/2015            ##
## fff    fff5555    555             Last Updated: 12/09/2015            ##
##  ff    fff 55555  55                                                  ##
##   f    fff  555   5       This script will finish setting up a full   ##
##   f    fff       55       Open Cart Web Server with updates           ##
##    ffffffff5555555                                                    ##
##       fffffff55                                                       ##
###########################################################################
###########################################################################
##                              Change Log                               ##
###########################################################################
## Version #     Name       #                    NOTES                   ##
###########################################################################
## 11/23/15#  Thomas Stanley#    Created base functionality              ##
###########################################################################

sudo apt-get update

sudo apt-get -y install build-essential libssl-dev binutils binutils-dev openssl
sudo apt-get -y install libdb-dev libexpat1-dev automake checkinstall unzip elinks sshpass

sudo apt-get -y install apache2 libapache2-mod-perl2
sudo apt-get -y install libcrypt-ssleay-perl libwww-perl libhtml-parser-perl libwww-mechanize-perl
sudo apt-get -y install php5
sudo apt-get -y install lamp-server

sudo a2enmod ssl
sudo a2ensite default-ssl

sudo apt-get -y install php5-mcrypt
sudo php5enmod mcrypt
sudo apt-get -y install php5-gd
sudo apt-get -y install php5-curl
sudo apt-get -y install php5-mysql
//sudo service apache2 restart

sudo unzip ./opencart-3.0.2.0.zip -d opencart-3.0.2.0
echo "Finished inflating zip file."

sudo chmod 777 -R /var/www/html
//sudo mkdir /var/www/html/opencart
//sudo chmod 777 -R /var/www/html/opencart

sudo mv opencart-3.0.2.0/upload/* /var/www/html/.
sudo cd /var/www/html
sudo mv config-dist.php config.php
sudo mv admin/config-dist.php admin/config.php
chown -R www-data:www-data /var/www/html
sudo echo "Moved config files."

echo "Wait for the SQL server to come alive!"
i=0
#while [ $i == 0 ]
#do
#sshpass -p${4} ssh -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no ${3}@$2 "mysql -u opencart -p${4} -Bse 'select 1;'"
#status=$?
#if [ $status == 0 ]
#then
#   i=$[$i+1]
#else
#   echo "Sleeping for 10 seconds while we wait for the MySQL server to come online."
#   sleep 10
#fi
#done
echo "SQL server is now alive."

# self ip 
selfid=${1}

# server ip
sqlserver=${2}
echo "Grabbed the IP address ($sqlserver) of the SQL Server."
//sleep 30
# Try to install OpenCart via command line.
i2=0
//sudo php /var/www/html/opencart/install/cli_install.php install --db_hostname $sqlserver --db_username "opencart" --db_password "anna" --db_database "opencart" --db_driver mysqli --username "root" --password "anna" --email "anna@f5.com" --http_server "http://localhost/opencart/" || i2=$[$i2+1]
sleep 30

//sudo sed -e 's|/html|/html/opencart|' -i /etc/apache2/sites-available/000-default.conf /etc/apache2/sites-available/default-ssl.conf
//echo "Edited the apache files."
//sudo chmod 777 -R /var/www/html/opencart
//echo "chmod opencart directory."
//rm -dfr /var/www/html/opencart/install
//echo "Deleted opencart install directory."
//sudo service apache2 restart
echo "Restarted Apache."
echo "This Apache Web Server is now hosting OpenCart..."
