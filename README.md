# Salt and Vagrant to deploy project


## Overview
The Vagrant files launch three EC2 instances:
- master instance: installs salt-master on it.
- website-minion instance: installs salt-minion on it.
- etl-minion instance: installs salt-minion on it.

Then, you will ssh into the salt-master and launch states to configure environments for:
- a django application providing a website and an api
- an application that will regularly extract data from transilien's API, apply transformations, and save what is useful in a Dynamo database.

## Why Vagrant AND Salt?

Salt provides a cloud solution to launch EC2 instances and provision them, but requires to have a salt-master with a fixed IP. So it can not be your laptop. The best solution I found is to set up a master on EC2.

The problem was the ability to easily update salt files and configs.

That's where Vagrant provides better functionalities. An important one is the synced_folder. Every change you will make on you local computer will be easily synced on the EC2's salt-master.

## Requirements and configuration customization

### Initial set-up
Git, VirtualBox and Vagrant must already be installed on your machine.

```
git clone https://github.com/leonardbinet/salt-vagrant-sncf-project.git
cd salt-vagrant-sncf-project
```
### Customization
Then, customize these files according to your needs.
- vagrant secrets
- vagrant settings
- salt secrets: secrets.sls pillar values
- salt settings: settings.sls pillar values

First, edit 'settings.sls' and 'secrets.sls' pillar files.

The only information you have to provide is: in 'settings.sls'

- **project_name** : no impact on application, just avoid spaces or special characters
- **git_rev**: your repo's branch name: for instance "master"
- **git_repo**: your repo's URL
- **DJANGO_SETTINGS_MODULE**: your application settings location, for instance: 'myapp.settings' (python import style: '.', not '/')
- **wsgi_app_loc**: for instance: 'myapp.wsgi'

Then if your application needs somes secrets to be included in your environment variables, just add them to the 'secrets.sls' pillar file.

## Instructions to launch instances on EC2 with Vagrant

```
vagrant plugin install vagrant-vbguest
vagrant plugin install vagrant-aws
vagrant up
```

This will launch EC2 instances on AWS. They will be configured with ubuntu xenial64 images.

Remember that `pillar` and `salt` folder will be synced between your local machine and the remote master EC2 instance.

## Instructions to apply configuration to salt-minions on EC2 with Salt

You can then run the following commands to log into the Salt Master and begin using Salt.
```
vagrant ssh master

# to test if your minions are responding
sudo salt '*' test.ping

# apply pillar changes
salt '*' saltutil.refresh_pillar

# apply states: it can take some time the first time (build python3.5 and pip requirements)
salt '*' state.apply
```

### Enjoy deploy
The website should be available on the minions' IPs:
- minion1: 192.168.50.11
- minion2: 192.168.50.12

## Requirements on your Django structure
In order to work properly, these salt states assume:
- that your application works with python3.5
- that your python requirements are written on a 'requirements.txt' file, in the root directory of your repo.

About secrets. I've tried to make it easy to add secrets and avoid to add it in your repositories. You can:
- have your django application read it from environment: in this case you need to add your secrets in the 'secrets.sls' pillar.


## TODO

### Secrets handling
I couldn't yet set environment variables for gunicorn. I tryed:
- putting it in virtualenv activate script: doesn't work
- putting it in bashrc or profile.d: didn't work eiter

**Current workaround:**
- writing it in a json file, that is put in source folder, and read from django settings module

**Ideal solution:**
- would be to read it directly from environment

### Logs
- currently django logs seems to be created by root user, and then cannot be edited by gunicorn's www-data user. (might be collectstatic or bower commands)

**Current workaround:**
- salt state to change permissions on django.logs file

**Ideal solution:**
- find which command creates automatically this root-owned django.logs

### Bower django
- current difficulties: permissions, or shell prompt requiring answer

**Current workaround**
- ssh into minions and run command directly so I can answers prompts
- use salt's stdin: `salt '*' cmd.run "my command" stdin='one\ntwo\nthree\nfour\nfive\n'`

**Ideal solution**
- should work with salt states
