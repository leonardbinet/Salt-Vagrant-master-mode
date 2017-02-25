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

## Instructions to configure machines environments

You can then run the following commands to log into the Salt Master and begin using Salt.
```
vagrant ssh master
sudo salt \* test.ping
```
