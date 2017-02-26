include:
  - website.venv_requirements

bower install:
  npm.installed:
    - name: bower


# Encountered problems when launching django. django.logs: owner root instead of www-data-> problems
# This is not a nice workaround, right now. I should set django location as a environment variable, and change my django code so it sets logs location according to what is in environment.
# Problem, I encounter problems setting up environment variables
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

# Does not work properly: still here to help debugging later
# If error:
# /home/ubuntu/sites/myproject/virtualenv/bin/python3 /home/ubuntu/sites/myproject/source/manage.py bower install
cmd_update_bower_files:
  cmd.run:
    - runas: ubuntu
    - name: "{{ pillar['project_venv'] }}/bin/python {{ pillar['project_source'] }}/manage.py bower_install"
    - stdin: '1\n'


components-directory:
  file.directory:
    - name: {{ pillar['project_source'] }}/components/bower_components
    - makedirs: True
    - user: {{ pillar['user'] }}
    - group: {{ pillar['group'] }}
    - mode: 777
