include:
  - website.venv_requirements

bower install:
  npm.installed:
    - name: bower

# Does not work properly: still here to help debugging later
# If error:
# /home/ubuntu/sites/SNCF_project/virtualenv/bin/python /home/ubuntu/sites/SNCF_project/source/manage.py bower install
cmd_update_bower_files:
  cmd.run:
    - runas: ubuntu
    - name: ". {{ pillar['project_venv'] }}/bin/activate && {{ pillar['project_venv'] }}/bin/python {{ pillar['project_source'] }}/manage.py bower install"
    - stdin: '1\n'
    - require:
      - bower install
      - components-directory



components-directory:
  file.directory:
    - name: {{ pillar['project_source'] }}/components/bower_components
    - makedirs: True
    - user: {{ pillar['user'] }}
    - group: {{ pillar['group'] }}
    - mode: 777

# Encountered problems when launching django. django.logs: owner root instead of www-data-> problems
# This is not a nice workaround, right now. I should set django location as a environment variable, and change my django code so it sets logs location according to what is in environment.
# Problem, I encounter problems setting up environment variables
django logs file:
  file.managed:
    - name: {{ pillar['project_logs'] }}/django.logs
    - user: {{ pillar['user'] }}
    - group: {{ pillar['group'] }}
    - mode: 777


# Two commands to try to do the same thing
# Requirements: use django prod settings: DJANGO_SETTINGS_MODULE -> prod
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
    - name: ". {{ pillar['project_venv'] }}/bin/activate && python {{ pillar['project_source'] }}/manage.py collectstatic --no-input"
    - require:
      - cmd_update_bower_files
      - django logs file
