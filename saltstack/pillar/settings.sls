# Replace values to match your requirements

{% set project_name = 'SNCF_project_website' %}
{% set project_dir = '/home/ubuntu/sites/'+project_name %}
{% set project_source = project_dir+'/source' %}
{% set project_venv = project_dir+'/virtualenv' %}
{% set project_logs = project_dir+'/logs' %}
{% set static = '/var/www' %}

git_rev: master
git_repo: https://github.com/leonardbinet/SNCF_project_website
DJANGO_SETTINGS_MODULE: sncfweb.settings.prod

# Do not change

static: {{ static }}/static

user: www-data
group: www-data

project_name: {{ project_name }}
project_dir: {{ project_dir }}
project_source: {{ project_source }}
project_venv: {{ project_venv }}
project_logs: {{ project_logs }}
