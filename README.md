# Salt and Vagrant demo to deploy a django project

The Vagrant part is inspired by https://github.com/UtahDave/salt-vagrant-demo.

The only change I made on the Vagrant file was to set images to be xenial64 instead of trusty64, in order to get ubuntu 16 instead of ubuntu 14.

The salt states and pillars are configured so you can easily run a django project. The only changes you have to make are to configure:
- secrets.sls pillar values
- settings.sls pillar values


## Instructions to set up virtual machines

Run the following commands in a terminal. Git, VirtualBox and Vagrant must already be installed on your machine.

```
git clone https://github.com/leonardbinet/salt-vagrant-django.git
cd salt-vagrant-django
vagrant plugin install vagrant-vbguest
vagrant up
```


This will download an Ubuntu VirtualBox image and create three virtual machines for you. One will be a Salt Master named master and two will be Salt Minions named minion1 and minion2. The Salt Minions will point to the Salt Master and the Minion's keys will already be accepted. Because the keys are pre-generated and reside in the repo, please be sure to regenerate new keys if you use this for production purposes.

## Instructions to configure virtual machines environments

### Customization
First, edit 'settings.sls' and 'secrets.sls' pillar files.

The only information you have to provide is: in 'settings.sls'

- project_name
- git_rev
- git_repo
- DJANGO_SETTINGS_MODULE
- wsgi_app_loc

Then if your application needs somes secrets to be included in your environment variables, just add them to the 'secrets.sls' pillar file.

### Apply configuration
You can then run the following commands to log into the Salt Master and begin using Salt.
```
vagrant ssh master

# to test if your minions are responding
sudo salt \* test.ping

# apply pillar changes
salt '*' saltutil.refresh_pillar

# apply states: it can take some time the first time (build python3.5 and pip requirements)
salt '*' state.apply
```

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
Current workaround:
- writing it in a json file, that is put in source folder, and read from django settings module
Ideal solution:
- would be to read it directly from environment

### Logs
- currently django logs seems to be created by root user, and then cannot be edited by gunicorn's www-data user. (might be collectstatic or bower commands)
Current workaround:
- salt state to change permissions on django.logs file
Ideal solution:
- find which command creates automatically this root-owned django.logs
