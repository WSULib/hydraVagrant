#!/bin/sh

echo "Non-vagrant install of WSUDOR"

SHARED_DIR=$1

# adduser user vagrant
# add to sudoers
# change to user vagrant

source ../install_scripts/bootstrap.sh
source ../install_scripts/java.sh
source ../install_scripts/tomcat7.sh
source ../install_scripts/solr.sh
source ../install_scripts/fedora4.sh
source ../install_scripts/fuseki.sh
source ../install_scripts/karaf.sh
source ../install_scripts/fedora_camel_toolbox.sh
source ../install_scripts/imagemagick.sh
source ../install_scripts/hydra.sh
source ../install_scripts/apache2.sh