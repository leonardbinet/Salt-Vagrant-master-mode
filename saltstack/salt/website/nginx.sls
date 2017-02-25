# check if static file is present with right permissions

users:
  user.present:
    - name: www-data
    - empty_password: true
    - groups:
      - www-data

static-directory:
  file.directory:
    - name: {{ pillar['static'] }}/static
    - makedirs: True
    - user: www-data
    - group: www-data
    - mode: 755

static_environment:
   environ.setenv:
     - name: static
     - value: {{ pillar['static'] }}
     - update_minion: True
