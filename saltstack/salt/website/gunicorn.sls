#include:
#  - website.venv_requirements
#
#gunicorn installed:
#  pip.installed:
#    - name: gunicorn
#    - bin_env: /home/ubuntu/sites/{{ pillar['project_name'] }}/virtualenv/
#    - require:
#      - create and update python virtualenv

gunicorn service file:
  file.managed:
    - name: /etc/systemd/system/gunicorn_{{ pillar['project_name'] }}.service
    - template: jinja
    - source: salt://website/gunicorn_service.jinga
    - user: {{ pillar['user'] }}
    - group: {{ pillar['group'] }}
#    - require:
#      - gunicorn installed

gunicorn_service running:
  service.running:
    - name: gunicorn_{{ pillar['project_name'] }}
    - enable: True
    - reload: True
    - require:
      - file: gunicorn service file
