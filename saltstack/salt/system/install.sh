#!/bin/bash

cd /usr/local/src/
wget "http://www.python.org/ftp/python/3.5.3/Python-3.5.3.tgz"
tar -xvzf Python-3.5.3.tgz
cd Python-3.5.3
./configure --prefix=/opt/python
make
make install
