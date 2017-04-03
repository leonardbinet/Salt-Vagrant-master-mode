{% set secrets = pillar.get('secrets', {}) %}

include:
  - system.other_python

etl delete possible failed builds:
  file.absent:
    - name: {{ pillar['project_venv'] }}/build/

etl create and update python virtualenv:
  virtualenv.managed:
    - name: {{ pillar['project_venv'] }}
    - venv_bin: /usr/bin/virtualenv
    - python: /usr/bin/python3
    # /opt/python/bin/python3.5, if python3 is created from source
    - env_vars:
      {% for key, value in secrets.items() -%}
      - {{ key }}: {{ value }}
      {% endfor -%}
    - require:
      - etl delete possible failed builds

etl install dependencies:
  pip.installed:
    - requirements: {{ pillar['project_source'] }}/requirements.txt
    - bin_env: {{ pillar['project_venv'] }}
    - require:
      - etl create and update python virtualenv
