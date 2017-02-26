# -*- mode: ruby -*-
# vi: set ft=ruby :

require 'yaml'

current_dir = File.dirname(File.expand_path(__FILE__))
secrets = YAML.load_file("#{current_dir}/secrets.yaml")
vagrant_secrets = secrets['secrets']


VAGRANTFILE_API_VERSION = "2"

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
  # The box is needed, but not used (ami instead)
  config.vm.box = "dummy"
  config.vm.box_url = "https://github.com/mitchellh/vagrant-aws/raw/master/dummy.box"
  config.vm.synced_folder "saltstack/salt/", "/srv/salt"
  config.vm.synced_folder "saltstack/pillar/", "/srv/pillar"

  # Provider
  config.vm.provider :aws do |aws, override|
    aws.access_key_id = vagrant_secrets['access_key_id']
    aws.secret_access_key = vagrant_secrets['secret_access_key']
    aws.keypair_name = "aws-eb2"
    # AWS AMI: ubuntu xenial64
    aws.ami = "ami-405f7226"
    aws.region = "eu-west-1"
    aws.instance_type = "t2.nano"
    aws.tags = { 'Name' => 'salt-master' }
    aws.security_groups = [ 'vagrant' ]

    override.ssh.username = "ubuntu"
    override.ssh.private_key_path = "~/.ssh/aws-eb2"
  end

  # Provisioning
  config.vm.provision :salt do |salt|
    salt.master_config = "saltstack/etc/master"
    salt.install_type = "stable"
    salt.install_master = true
    salt.no_minion = true
    salt.verbose = true
    salt.colorize = true
    salt.bootstrap_options = "-P -c /tmp"
  end

end
#####################
