python-install:
  cmd.script:
    - name: salt://system/install.sh
    - unless: /opt/python/bin/python3 -V | grep 3.5.3

python-source:
  file.managed:
    - name: /usr/local/src/Python-3.5.3.tgz
    - source: http://www.python.org/ftp/python/3.5.3/Python-3.5.3.tgz
    - skip_verify: true
    - makedirs: true
    - replace: false
    #- source_hash: md5=57d1f8bfbabf4f2500273fb0706e6f21
