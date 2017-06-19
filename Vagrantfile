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
  # GENERAL CONFIGURATION
  # The box is needed, but not used (ami instead)
  config.vm.box = "dummy"
  config.vm.box_url =    "https://github.com/mitchellh/vagrant-aws/raw/master/dummy.box"

  # common aws provider configuration
  config.vm.provider :aws do |aws_config, override|
    aws_config.access_key_id = vagrant_secrets['access_key_id']
    aws_config.secret_access_key = vagrant_secrets['secret_access_key']
    aws_config.keypair_name = vagrant_config['keypair_name']
    aws_config.ami = vagrant_config['ami']
    aws_config.region = vagrant_config['region']

    override.ssh.username = "ubuntu"
    override.ssh.private_key_path = vagrant_config['private_key_path']
  end

  # SPECIFIC CONFIGURATION
  # MASTER
  config.vm.define :master do |master_config|
    master_config.vm.synced_folder "saltstack/salt/", "/srv/salt"
    master_config.vm.synced_folder "saltstack/pillar/", "/srv/pillar"

    master_config.vm.provider :aws do |aws_master, override|
      aws_master.instance_type = vagrant_config['master_instance_type']
      aws_master.tags = { 'Name' => 'salt-master' }
      aws_master.security_groups = [ vagrant_config['master_security_group'] ]
      aws_master.elastic_ip = vagrant_config['master_elastic_ip']
    end

    # Provisioning
    master_config.vm.provision :salt do |salt|
      salt.install_type = "stable"
      salt.verbose = true
      salt.colorize = true
      salt.bootstrap_options = "-P -c /tmp"

      salt.master_config = "saltstack/etc/salt/master"
      salt.master_key = "saltstack/keys/master_minion"
      salt.master_pub = "saltstack/keys/master_minion.pub"
      salt.seed_master = {
        "minion_website" => "saltstack/keys/minion_website.pub",
        "minion_etl" => "saltstack/keys/minion_etl.pub",
        "minion_worker" => "saltstack/keys/minion_worker.pub",
      }
      salt.install_master = true
    end
  end

  # MINION WEBSITE
  config.vm.define :minion_website do |website_config|
    # Provider
    website_config.vm.provider :aws do |aws_website, override|
      aws_website.instance_type = vagrant_config['minion_website_instance_type']
      aws_website.tags = { 'Name' => 'salt-website-minion' }
      aws_website.security_groups = [ vagrant_config['minion_website_security_group'] ]
      aws_website.elastic_ip = vagrant_config['minion_website_elastic_ip']
    end

    # Provisioning
    website_config.vm.provision :salt do |salt|
      salt.install_type = "stable"
      salt.verbose = true
      salt.colorize = true
      salt.bootstrap_options = "-P -c /tmp"

      salt.minion_config = "saltstack/etc/salt/minion_website"
      salt.minion_key = "saltstack/keys/minion_website"
      salt.minion_pub = "saltstack/keys/minion_website.pub"
    end
  end

  # MINION ETL
  config.vm.define :minion_etl do |etl_config|
    # Provider
    etl_config.vm.provider :aws do |aws_etl, override|
      aws_etl.instance_type = vagrant_config['minion_etl_instance_type']
      aws_etl.tags = { 'Name' => 'salt-etl-minion' }
      aws_etl.security_groups = [ vagrant_config['minion_etl_security_group'] ]
      aws_etl.elastic_ip = vagrant_config['minion_etl_elastic_ip']
    end

    # Provisioning
    etl_config.vm.provision :salt do |salt|
      salt.install_type = "stable"
      salt.verbose = true
      salt.colorize = true
      salt.bootstrap_options = "-P -c /tmp"

      salt.minion_config = "saltstack/etc/salt/minion_etl"
      salt.minion_key = "saltstack/keys/minion_etl"
      salt.minion_pub = "saltstack/keys/minion_etl.pub"
    end
  end

  # MINION WORKER
  config.vm.define :minion_worker do |worker_config|
    # Provider
    worker_config.vm.provider :aws do |aws_worker, override|
      aws_worker.instance_type = vagrant_config['minion_worker_instance_type']
      aws_worker.tags = { 'Name' => 'salt-worker-minion' }
      aws_worker.security_groups = [ vagrant_config['minion_worker_security_group'] ]
      aws_worker.elastic_ip = vagrant_config['minion_worker_elastic_ip']
    end

    # Provisioning
    worker_config.vm.provision :salt do |salt|
      salt.install_type = "stable"
      salt.verbose = true
      salt.colorize = true
      salt.bootstrap_options = "-P -c /tmp"

      salt.minion_config = "saltstack/etc/salt/minion_worker"
      salt.minion_key = "saltstack/keys/minion_worker"
      salt.minion_pub = "saltstack/keys/minion_worker.pub"
    end
  end
end
#####################
