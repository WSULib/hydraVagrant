############
# Hydra 9.1.0.rc1
############

echo "Installing Hydra."

SHARED_DIR=$1

if [ -f "$SHARED_DIR/install_scripts/config" ]; then
  . $SHARED_DIR/install_scripts/config
fi

add-apt-repository ppa:brightbox/ruby-ng
apt-get update -qq

apt-get install -y software-properties-common ruby2.2 ruby2.2-dev oracle-java8-installer oracle-java8-set-default zlib1g-dev unzip libsqlite3-dev xmlstarlet

sudo gem install rails bundler

sudo mkdir /webapps/
sudo chown vagrant:vagrant /webapps

cd $HYDRA_DIR

rails new hydra
# Can also instantiate project with mysql with following: rails hydra -d mysql

cd hydra

printf "\n gem 'hydra', '9.1.0.rc1'" >> Gemfile
printf "\n gem 'therubyracer', platforms: :ruby" >> Gemfile

bundle install

rails generate hydra:install
sudo chown -R vagrant:vagrant /webapps/hydra/

sudo chown -R vagrant:vagrant hydra/

sudo find ./config -type f -exec sed -i 's/8983/8080/g' {} +

sudo find ./config/fedora.yml -type f -exec sed -i 's/8080\/fedora/8080\/fcrepo/g' {} +

sudo find ./config/solr.yml -type f -exec sed -i 's/solr\/development/solr\/collection1/g' {} +

sudo find ./config/blacklight.yml -type f -exec sed -i 's/solr\/development/solr\/collection1/g' {} +

printf "\n class Application < Rails::Application
  config.web_console.whitelisted_ips = '10.0.2.2'
end" >> ./config/environments/development.rb

# Copy Hydra Solr conf files (solrconf.xml and schema.xml) to Solr core location
	sudo mv $SOLR_HOME/collection1/conf/solrconfig.xml $SOLR_HOME/collection1/conf/solrconfig-old.xml
	sudo mv $SOLR_HOME/collection1/conf/schema.xml $SOLR_HOME/collection1/conf/schema-old.xml

	sudo cp /home/vagrant/hydra/solr_conf/conf/solrconfig.xml $SOLR_HOME/collection1/conf/solrconfig.xml
	sudo cp /home/vagrant/hydra/solr_conf/conf/schema.xml $SOLR_HOME/collection1/conf/schema.xml
	sudo chown tomcat7:tomcat7 $SOLR_HOME/collection1/conf/solrconfig.xml $SOLR_HOME/collection1/conf/schema.xml

# Fix Version number issue (aka Hydra's default solr version does not match current)
lucene_version=$(xmlstarlet sel -t -m '//luceneMatchVersion' -v . -n </var/lib/tomcat7/solr/collection1/conf/solrconfig-old.xml)

sudo xmlstarlet edit --inplace --update '//luceneMatchVersion' --value $lucene_version /var/lib/tomcat7/solr/collection1/conf/solrconfig.xml


######### Add lib and lucene-libs in Solr analysis-extras libraries for modern SOLR/Hydra ######### 
sudo cp -r /tmp/solr-"$SOLR_VERSION"/contrib/analysis-extras/lib/* /var/lib/tomcat7/webapps/solr/WEB-INF/lib/
sudo cp -r /tmp/solr-"$SOLR_VERSION"/contrib/analysis-extras/lucene-libs/* /var/lib/tomcat7/webapps/solr/WEB-INF/lib/

sudo chown -R tomcat7:tomcat7 /var/lib/tomcat7/webapps/solr/WEB-INF/lib/

sudo service tomcat7 restart

echo "Now run the following commands:"
echo "vagrant ssh"
echo "cd hydra/"
echo "sudo rails server -b 0.0.0.0"
echo "Now go to IP:3000 to see your Hydra instance"



