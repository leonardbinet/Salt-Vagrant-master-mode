{% set secrets = pillar.get('secrets', {}) %}

include:
  - system.other_python
  - website.source_code

delete possible failed builds:
  file.absent:
    - name: {{ pillar['project_venv'] }}/build/

create and update python virtualenv:
  virtualenv.managed:
    - name: {{ pillar['project_venv'] }}
    - venv_bin: /usr/bin/virtualenv
    - python: /usr/bin/python3
    # /opt/python/bin/python3.5, if python3 is created from source
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
    - requirements: {{ pillar['project_source'] }}/requirements.txt
    - bin_env: {{ pillar['project_venv'] }}
    - require:
      - create and update python virtualenv
      - website source code
