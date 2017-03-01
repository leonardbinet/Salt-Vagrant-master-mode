# -*- mode: ruby -*-
# vi: set ft=ruby :

require 'yaml'

current_dir = File.dirname(File.expand_path(__FILE__))

secrets = YAML.load_file("#{current_dir}/vagrant_secrets.yaml")
vagrant_secrets = secrets['secrets']

config = YAML.load_file("#{current_dir}/vagrant_config.yaml")
vagrant_config = config['config']

VAGRANTFILE_API_VERSION = "2"

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
  # The box is needed, but not used (ami instead)
  config.vm.box = "dummy"
  config.vm.box_url =    "https://github.com/mitchellh/vagrant-aws/raw/master/dummy.box"

  config.vm.define :master do |master_config|
    master_config.vm.synced_folder "saltstack/salt/", "/srv/salt"
    master_config.vm.synced_folder "saltstack/pillar/", "/srv/pillar"

    # Provider
    master_config.vm.provider :aws do |aws_master, override|
      # aws.name = "master"
      aws_master.access_key_id = vagrant_secrets['access_key_id']
      aws_master.secret_access_key = vagrant_secrets['secret_access_key']
      aws_master.keypair_name = vagrant_config['keypair_name']
      # AWS AMI: ubuntu xenial64
      aws_master.ami = vagrant_config['ami']
      aws_master.region = vagrant_config['region']
      aws_master.instance_type = vagrant_config['master_instance_type']
      aws_master.tags = { 'Name' => 'salt-master' }
      aws_master.security_groups = [ vagrant_config['master_security_group'] ]
      aws_master.elastic_ip = vagrant_config['master_elastic_ip']
      override.ssh.username = "ubuntu"
      override.ssh.private_key_path = vagrant_config['private_key_path']
    end

    # Provisioning
    master_config.vm.provision :salt do |salt|
      salt.master_config = "saltstack/etc/salt/master"
      salt.master_key = "saltstack/keys/master_minion"
      salt.master_pub = "saltstack/keys/master_minion.pub"
      salt.minion_key = "saltstack/keys/master_minion"
      salt.minion_pub = "saltstack/keys/master_minion.pub"
      salt.seed_master = {
                          "minion_website" => "saltstack/keys/minion_website.pub",
                          "minion_etl" => "saltstack/keys/minion_etl.pub"
                         }
      salt.install_type = "stable"
      salt.install_master = true
      salt.no_minion = true
      salt.verbose = true
      salt.colorize = true
      salt.bootstrap_options = "-P -c /tmp"
    end
  end

  config.vm.define :minion_website do |website_config|
    # Provider
    website_config.vm.provider :aws do |aws_website, override|
      # aws.name = "website_minion"
      aws_website.access_key_id = vagrant_secrets['access_key_id']
      aws_website.secret_access_key = vagrant_secrets['secret_access_key']
      aws_website.keypair_name = vagrant_config['keypair_name']
      # AWS AMI: ubuntu xenial64
      aws_website.ami = vagrant_config['ami']
      aws_website.region = vagrant_config['region']
      aws_website.instance_type = vagrant_config['minion_website_instance_type']
      aws_website.tags = { 'Name' => 'salt-website-minion' }
      aws_website.security_groups = [ 'vagrant-website' ]

      override.ssh.username = "ubuntu"
      override.ssh.private_key_path = vagrant_config['private_key_path']
    end

    # Provisioning
    website_config.vm.provision :salt do |salt|
      salt.minion_config = "saltstack/etc/salt/minion_website"
      salt.minion_key = "saltstack/keys/minion_website"
      salt.minion_pub = "saltstack/keys/minion_website.pub"
      salt.install_type = "stable"
      salt.verbose = true
      salt.colorize = true
      salt.bootstrap_options = "-P -c /tmp"
    end
  end

  config.vm.define :minion_etl do |etl_config|
    # Provider
    etl_config.vm.provider :aws do |aws_etl, override|
      # aws.name = "website_minion"
      aws_etl.access_key_id = vagrant_secrets['access_key_id']
      aws_etl.secret_access_key = vagrant_secrets['secret_access_key']
      aws_etl.keypair_name = vagrant_config['keypair_name']
      # AWS AMI: ubuntu xenial64
      aws_etl.ami = vagrant_config['ami']
      aws_etl.region = vagrant_config['region']
      aws_etl.instance_type = vagrant_config['minion_etl_instance_type']
      aws_etl.tags = { 'Name' => 'salt-etl-minion' }
      aws_etl.security_groups = [ 'vagrant' ]

      override.ssh.username = "ubuntu"
      override.ssh.private_key_path = vagrant_config['private_key_path']
    end

    # Provisioning
    etl_config.vm.provision :salt do |salt|
      salt.minion_config = "saltstack/etc/salt/minion_etl"
      salt.minion_key = "saltstack/keys/minion_etl"
      salt.minion_pub = "saltstack/keys/minion_etl.pub"
      salt.install_type = "stable"
      salt.verbose = true
      salt.colorize = true
      salt.bootstrap_options = "-P -c /tmp"
    end
  end
end
#####################
