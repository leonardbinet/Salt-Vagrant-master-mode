{% set secrets = pillar.get('secrets', {}) %}

include:
  - system.other_python
  - website.source_code

delete possible failed builds:
  file.absent:
    - name: /home/ubuntu/sites/{{ pillar['project_name'] }}/virtualenv/build/

create and update python virtualenv:
  virtualenv.managed:
    - name: /home/ubuntu/sites/{{ pillar['project_name'] }}/virtualenv
    - venv_bin: /usr/bin/virtualenv
    - python: /opt/python/bin/python3.5
    - env_vars:
      - DJANGO_SETTINGS_MODULE: {{ pillar['DJANGO_SETTINGS_MODULE'] }}
      {% for key, value in secrets.items() -%}
      - {{ key }}: {{ value }}
      {% endfor -%}
    - require:
      - website source code
      - delete possible failed builds

install dependencies:
  pip.installed:
    - requirements: /home/ubuntu/sites/{{ pillar['project_name'] }}/source/requirements.txt
    - bin_env: /home/ubuntu/sites/{{ pillar['project_name'] }}/virtualenv/
    - require:
      - create and update python virtualenv
      - website source code
