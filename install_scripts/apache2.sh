############
# Apache 2 + Passenger
# following much of this: https://nathanhoad.net/how-to-ruby-on-rails-ubuntu-apache-with-passenger
############

echo "Installing Apache2 and Passenger."

SHARED_DIR=$1

if [ -f "$SHARED_DIR/install_scripts/config" ]; then
  . $SHARED_DIR/install_scripts/config
fi

if [ -f "$SHARED_DIR/install_scripts/sensitive" ]; then
  . $SHARED_DIR/install_scripts/sensitive
fi

sudo apt-get -y install apache2 apache2-mpm-prefork apache2-prefork-dev

sudo debconf-set-selections <<< 'mysql-server mysql-server/root_password password $SQL_PASSWORD'
sudo debconf-set-selections <<< 'mysql-server mysql-server/root_password_again password $SQL_PASSWORD'

sudo apt-get install -y mysql-server mysql-client ruby-mysql libmysqlclient-dev libcurl4-openssl-dev
sudo gem install mysql passenger

sudo passenger-install-apache2-module --auto

GEM_LOCATION="$(gem env gemdir)"
cd $GEM_LOCATION/gems/
PASSENGER_VERSION="$(find passenger* $GEM_LOCATION/gems/ | head -n 1)"
RUBY_EXECUTABLE="$(gem env | grep 'RUBY EXECUTABLE:' | cut -f2- -d':')"
# passenger-config --version

# Next is to put the below in apache2.conf and then add in mod_rewrite and restart Apache.
sudo printf "\nLoadModule passenger_module $GEM_LOCATION/gems/$PASSENGER_VERSION/buildout/apache2/mod_passenger.so
   <IfModule mod_passenger.c>
     PassengerRoot $GEM_LOCATION/gems/$PASSENGER_VERSION
     PassengerDefaultRuby $RUBY_EXECUTABLE
   </IfModule>" >> /etc/apache2/apache2.conf

sudo a2enmod rewrite

sudo touch /etc/apache2/sites-available/$VH_NAME.conf

sudo printf "<VirtualHost *:80>
    #ServerName example.com
    #ServerAlias www.example.com
    #ServerAdmin webmaster@localhost
    DocumentRoot /webapps/hydra/public
    RailsEnv development
    ErrorLog \${APACHE_LOG_DIR}/error.log
    CustomLog \${APACHE_LOG_DIR}/access.log combined
    <Directory '/webapps/hydra/public'>
      AllowOverride all
      # MultiViews must be turned off.
      Options -MultiViews
      Require all granted
      Options FollowSymLinks
      Allow from all
    </Directory>
</VirtualHost>" >> /etc/apache2/sites-available/$VH_NAME.conf

sudo a2dissite 000-default
sudo a2ensite $VH_NAME
sudo service apache2 restart

echo "Now go to IP:3000 to see your Hydra instance"