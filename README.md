# hydraVagrant
Vagrant/bash install and configuration of Hydra, FC4, Solr, and Fuseki
## Installation
#### Vagrant
1. Assuming a running instance of Vagrant and Virtualbox, adjust the values in VagrantFile to suit your needs.
2. Rename sensitive_example (found in install_scripts folders) to sensitive and edit.
3. Run vagrant up and navigate to host_machine_ip:3000 when installation is finished.

#### Bash install (still work in progress)
1. Assuming you have a copy of Ubuntu 14.04 running, edit sensitive_example (found in install_scripts folders) to sensitive and edit.
2. Run sudo bash install.sh
3. Navigate to host_machine_ip:3000 when installation is finished.

###### Credit
https://github.com/fcrepo4-exts/fcrepo4-vagrant
