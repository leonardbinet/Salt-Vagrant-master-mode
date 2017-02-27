gunicorn service file:
  file.managed:
    - name: /etc/systemd/system/gunicorn_{{ pillar['project_name'] }}.service
    - template: jinja
    - source: salt://website/gunicorn_service.jinga
    - user: {{ pillar['user'] }}
    - group: {{ pillar['group'] }}

gunicorn conf file:
  file.managed:
    - name: {{ pillar['project_conf'] }}/gunicorn_conf.py
    - template: jinja
    - source: salt://website/gunicorn_conf.jinga
    - user: {{ pillar['user'] }}
    - group: {{ pillar['group'] }}

gunicorn_service running:
  service.running:
    - name: gunicorn_{{ pillar['project_name'] }}
    - enable: True
    - reload: True
    - require:
      - file: gunicorn service file
