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

apt-get update

apt-get -y install build-essential libssl-dev binutils binutils-dev openssl
apt-get -y install libdb-dev libexpat1-dev automake checkinstall unzip elinks sshpass

apt-get -y install apache2 libapache2-mod-perl2
apt-get -y install libcrypt-ssleay-perl libwww-perl libhtml-parser-perl libwww-mechanize-perl
apt-get -y install php5
a2enmod ssl
a2ensite default-ssl
apt-get -y install php5-mcrypt
php5enmod mcrypt
apt-get -y install php5-gd
apt-get -y install php5-curl
apt-get -y install php5-mysql
service apache2 restart

unzip ./opencart-2.0.1.1.zip
echo "Finished inflating zip file."

chmod 777 -R /var/www/html
mkdir /var/www/html/opencart
chmod 777 -R /var/www/html/opencart

mv opencart-2.0.1.1/upload/* /var/www/html/opencart/.
mv /var/www/html/opencart/config-dist.php /var/www/html/opencart/config.php
mv /var/www/html/opencart/admin/config-dist.php /var/www/html/opencart/admin/config.php
echo "Moved config files."

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

# Try to install OpenCart via command line.
i2=0
php /var/www/html/opencart/install/cli_install.php install --db_hostname $sqlserver --db_username "opencart" --db_password $5 --db_database "opencart" --db_driver mysqli --username admin --password $4 --email "${3}@f5.com" --http_server "http://test.f5.quickstart.aws.com/"  || i2=$[$i2+1]
sleep 20
sed -e 's|/html|/html/opencart|' -i /etc/apache2/sites-available/000-default.conf /etc/apache2/sites-available/default-ssl.conf
echo "Edited the apache files."
chmod 777 -R /var/www/html/opencart
echo "chmod opencart directory."
rm -dfr /var/www/html/opencart/install
echo "Deleted opencart install directory."
service apache2 restart
echo "Restarted Apache."
echo "This Apache Web Server is now hosting OpenCart..."
