include:
  - website.venv_requirements

bower install:
  npm.installed:
    - name: bower

#update_bower_files:
#  module.run:
#    - name: django.command
#    - settings_module: {{ pillar['DJANGO_SETTINGS_MODULE'] }}
#    - command: 'bower install -- --allow-root'
#    - bin_env: {{ pillar['project_venv'] }}
#    - pythonpath: {{ pillar['project_source'] }}

# Encountered problems: owner root-> problems
django logs file:
  file.managed:
    - name: {{ pillar['project_logs'] }}/django.logs
    - user: {{ pillar['user'] }}
    - group: {{ pillar['group'] }}
    - mode: 777

update_static_files:
  module.run:
    - runas: {{ pillar['user'] }}
    - name: django.collectstatic
    - settings_module: {{ pillar['DJANGO_SETTINGS_MODULE'] }}
    - bin_env: {{ pillar['project_venv'] }}
    - pythonpath: {{ pillar['project_source'] }}

cmd_update_static_files:
  cmd.run:
    - runas: {{ pillar['user'] }}
    - name: "{{ pillar['project_venv'] }}/bin/python {{ pillar['project_source'] }}/manage.py collectstatic --no-input"

cmd_update_bower_files:
  cmd.run:
    - runas: {{ pillar['user'] }}
    - name: "{{ pillar['project_venv'] }}/bin/python {{ pillar['project_source'] }}/manage.py bower install"


components-directory:
  file.directory:
    - name: {{ pillar['project_source'] }}/components/bower_components
    - makedirs: True
    - user: {{ pillar['user'] }}
    - group: {{ pillar['group'] }}
    - mode: 777

# Made to not have errors with bower (require HOME)
HOME_environment:
   environ.setenv:
     - name: HOME
     - value: random
     - update_minion: True

# If error:
# /home/ubuntu/sites/SNCF_project_website/virtualenv/bin/python3 /home/ubuntu/sites/SNCF_project_website/source/manage.py bower install
