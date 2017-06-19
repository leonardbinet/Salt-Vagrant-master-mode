include:
  - etl.venv_requirements

RabbitMQ server install:
  pkg.installed:
    - name: rabbitmq-server

enable rabbit plugins:
  cmd.run:
    - runas: ubuntu
    - name: "rabbitmq-plugins enable rabbitmq_management"
    - require:
      - RabbitMQ server install


# Already in project virtual env
# install celery:
#  pip.installed:
#    - name: celery
#    - bin_env: {{ pillar['project_venv'] }}
#    - require:
#      - create and update python virtualenv
#
# install flower:
#  pip.installed:
#    - name: flower
#    - bin_env: {{ pillar['project_venv'] }}
#    - require:
#      - create and update python virtualenv

celery user:
  user.present:
    - name: celery
    - empty_password: true

celery group:
  group.present:
    - system: True
    - addusers:
      - celery
    - require:
        - celery user

celery logs-directory:
  file.directory:
    - name: {{ pillar['project_logs'] }}/celery
    - makedirs: True
    - user: {{ pillar['user'] }}
    - group: {{ pillar['group'] }}
    - mode: 777

celery runtime directory:
  file.directory:
    - name: /var/run/celery
    - makedirs: True
    - user: {{ pillar['user'] }}
    - group: {{ pillar['group'] }}
    - mode: 777

celery conf file:
  file.managed:
    - name: /etc/conf.d/celery
    - template: jinja
    - source: salt://etl/celery_conf.jinga
    - makedirs: true

celery service file:
  file.managed:
    - name: /etc/systemd/system/celery.service
    - template: jinja
    - source: salt://etl/celery_service.jinga
    - makedirs: true

celerybeat service file:
  file.managed:
    - name: /etc/systemd/system/celerybeat.service
    - template: jinja
    - source: salt://etl/celerybeat_service.jinga
    - makedirs: true

celeryflower service file:
  file.managed:
    - name: /etc/systemd/system/celeryflower.service
    - template: jinja
    - source: salt://etl/celeryflower_service.jinga
    - makedirs: true

rabbitmq-server running:
  service.running:
    - name: rabbitmq-server
    - enable: True
    - reload: True
    - require:
      - RabbitMQ server install

celery_service running:
  service.running:
    - name: celery
    - enable: True
    - reload: True
    - watch:
        - celery service file
    - require:
      - file: celery conf file
      - file: celery service file
      - rabbitmq-server running

celerybeat_service running:
  service.running:
    - name: celerybeat
    - enable: True
    - reload: True
    - watch:
        - celerybeat service file
    - require:
      - file: celery conf file
      - file: celerybeat service file
      - rabbitmq-server running

celeryflower_service running:
  service.running:
    - name: celeryflower
    - enable: True
    - reload: True
    - watch:
        - celeryflower service file
    - require:
      - file: celeryflower service file
      - rabbitmq-server running
