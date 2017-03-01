###### Replace values to match your requirements ######

# This setting is common to all minions
{% set project_name = 'SNCF_project' %} # no space or special character

# Website minion settings
{% set wsgi_app_loc = 'sncfweb.wsgi' %}
website_git_rev: master
website_git_repo: https://github.com/leonardbinet/SNCF_project_website
DJANGO_SETTINGS_MODULE: sncfweb.settings.prod

# Etl minion settings
etl_git_rev: master
etl_git_repo: https://github.com/leonardbinet/Transilien-Api-ETL.git


###### Do not change ######

{% set project_dir = '/home/ubuntu/application/'+project_name %}
{% set project_source = project_dir+'/source' %}
{% set project_venv = project_dir+'/virtualenv' %}
{% set project_logs = project_dir+'/logs' %}
{% set project_conf = project_dir+'/conf' %}
{% set project_static = '/var/www' %}

project_static: {{ project_static }}

user: www-data
group: www-data

project_name: {{ project_name }}
project_dir: {{ project_dir }}
project_source: {{ project_source }}
project_venv: {{ project_venv }}
project_logs: {{ project_logs }}
project_conf: {{ project_conf }}
