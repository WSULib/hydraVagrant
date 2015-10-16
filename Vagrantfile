# Vagrantfile API/syntax version. Don't touch unless you know what you're doing!
VAGRANTFILE_API_VERSION = "2"

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
  # All Vagrant configuration is done here. The most common configuration
  # options are documented and commented below. For a complete reference,
  # please see the online documentation at vagrantup.com.
  
  config.vm.hostname = "hydraDev"

  config.vm.box = "ubuntu/trusty64"

  config.vm.network :forwarded_port, guest: 8080, host: 8080 # Tomcat
  config.vm.network :forwarded_port, guest: 9080, host: 9080 # Fixity and Reindexing
  config.vm.network :forwarded_port, guest: 3000, host: 3000 # Hydra3000

  config.vm.provider "virtualbox" do |vb|
   # vb.memory = 5120
    vb.memory = 10240
    vb.cpus = 3
  end

  shared_dir = "/vagrant"

  config.vm.provision "shell", path: "./install_scripts/bootstrap.sh", args: shared_dir
  config.vm.provision "shell", path: "./install_scripts/java.sh", args: shared_dir
  config.vm.provision "shell", path: "./install_scripts/tomcat7.sh", args: shared_dir
  config.vm.provision "shell", path: "./install_scripts/solr.sh", args: shared_dir
  config.vm.provision "shell", path: "./install_scripts/fedora4.sh", args: shared_dir
  config.vm.provision "shell", path: "./install_scripts/fuseki.sh", args: shared_dir
  config.vm.provision "shell", path: "./install_scripts/karaf.sh", args: shared_dir
  config.vm.provision "shell", path: "./install_scripts/fedora_camel_toolbox.sh", args: shared_dir
  config.vm.provision "shell", path: "./install_scripts/imagemagick.sh"
  config.vm.provision "shell", path: "./install_scripts/hydra.sh", args: shared_dir

end
