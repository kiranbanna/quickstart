#!/bin/bash
apt-get update

apt-get -y install build-essential libssl-dev binutils binutils-dev openssl
apt-get -y install libdb-dev libexpat1-dev automake checkinstall unzip elinks sshpass
apt-get -y install curl wget lynx w3m

apt-get -y install apache2 libapache2-mod-perl2
apt-get -y install libcrypt-ssleay-perl libwww-perl libhtml-parser-perl libwww-mechanize-perl
apt-get -y install php5

a2enmod ssl
a2ensite default-ssl

apt-get -y install mysql-client-core-5.6
apt-get -y install php5-gd
apt-get -y install php5-curl
apt-get -y install php5-mysql
apt-get -y install php5-mcrypt

apt-get -y install mysql-client-core-5.5
apt-get -y install mariadb-client-core-5.5
apt-get -y install mysql-client-core-5.6
apt-get -y install percona-xtradb-cluster-client-5.5

php5enmod mcrypt
service apache2 restart

unzip ./opencart-3.0.2.0.zip -d opencart
echo "Finished inflating zip file."

chmod 777 -R /var/www/html
mkdir /var/www/html/opencart
chmod 777 -R /var/www/html/opencart

mv opencart/upload/* /var/www/html/opencart/.
mv /var/www/html/opencart/config-dist.php /var/www/html/opencart/config.php
mv /var/www/html/opencart/admin/config-dist.php /var/www/html/opencart/admin/config.php
echo "Moved config files."

echo "SQL server is now alive."

sqlserver=$1
url=$2
username=$3
password=$4

echo "Grabbed the following data:\n"
echo "SQL Server IP Address     =  $sqlserver \n" 
echo "WebServer URL             =  $url \n"
echo "Database Server user name =  $username \n"
echo "Database Server password  =  $password \n"

# Try to install OpenCart via command line.
i2=0
php /var/www/html/opencart/install/cli_install.php install --db_hostname $sqlserver --db_username "opencart" --db_password "anna" --db_database "opencart" --db_driver mysqli --db_port 3306 --username "opencart" --password 'anna' --email "anna@f5.com" --http_server $url || i2=$[$i2+1]

# We succeded because we were the first!
# Everyone else will fail, so we need to push our config to the others and restart their apache2 server.
sleep 10
sed -e 's|/html|/html/opencart|' -i /etc/apache2/sites-available/000-default.conf /etc/apache2/sites-available/default-ssl.conf
service apache2 restart
rm -dfr /var/www/html/opencart/install
echo "Restarted Apache."
