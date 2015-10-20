#!/bin/bash
PATH="$PATH":/home/vagrant/hydraVagrant/install_scripts
echo "Non-vagrant install of WSUDOR"

SHARED_DIR=$1
useradd -m -s /bin/bash vagrant
echo "vagrant:vagrant" | chpasswd
echo 'vagrant  ALL=(ALL:ALL) ALL' >> /etc/sudoers

/bin/bash bootstrap.sh
/bin/bash java.sh
/bin/bash tomcat7.sh
/bin/bash solr.sh
/bin/bash fedora4.sh
/bin/bash fuseki.sh
/bin/bash karaf.sh
/bin/bash fedora_camel_toolbox.sh
/bin/bash imagemagick.sh
/bin/bash hydra.sh
/bin/bash apache2.sh