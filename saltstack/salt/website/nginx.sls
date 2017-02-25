# check if static file is present with right permissions
users:
  user.present:
    - name: www-data
    - empty_password: true
    - groups:
      - www-data

static-directory:
  file.directory:
    - name: {{ pillar['project_static'] }}/static
    - makedirs: True
    - user: www-data
    - group: www-data
    - mode: 777

static_environment:
   environ.setenv:
     - name: static
     - value: {{ pillar['project_static'] }}
     - update_minion: True
