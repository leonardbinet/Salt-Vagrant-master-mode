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
    - dir_mode: 777
    - recurse:
      - user
      - group
      - mode
# recursive chmod seems to be broken, for now: manually
static-directory_man:
  file.directory:
    - name: {{ pillar['project_static'] }}
    - user: www-data
    - group: www-data
    - mode: 777

static-directory_man_2:
  file.directory:
    - name: /var
    - user: www-data
    - group: www-data
    - mode: 777

static_environment django:
   environ.setenv:
     - name: STATIC_ROOT
     - value: {{ pillar['project_static'] }}/static
     - update_minion: True
