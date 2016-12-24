# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|
  config.vm.box = "ubuntu/xenial64"
  config.vm.synced_folder "./", "/srv/salt", id: "vagrant-root"

  config.vm.provider "virtualbox" do |vb|
    vb.name = "ceph_ci"
    vb.memory = "1024"
  end

  config.vm.provision "shell", inline: <<-SHELL
    if [ ! -h /srv/salt/top.sls ] ; then ln -s /srv/salt/test/state_top.sls /srv/salt/top.sls ; fi
  SHELL
  config.vm.provision :salt do |salt|
    salt.masterless = true
    salt.pillar({
          "ceph" => {
            "config" => {
              "global" => {
                "fsid" => "0fffffff-35be-40a0-a76e-fff899cb85da",
                "authentication_type" => "none",
              },
            },
            "mon_hosts" => [
              "127.0.0.1",
            ],
          }
        })
    salt.colorize = true
    salt.verbose = true
    salt.log_level = "warning"
    salt.run_highstate = true
  end

end
