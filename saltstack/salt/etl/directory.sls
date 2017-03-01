project-directory:
  file.directory:
    - name: {{ pillar['project_dir'] }}
    - makedirs: True
    - user: {{ pillar['user'] }}
    - group: {{ pillar['group'] }}

source-directory:
  file.directory:
    - name: {{ pillar['project_source'] }}
    - makedirs: True
    - user: {{ pillar['user'] }}
    - group: {{ pillar['group'] }}

logs-directory:
  file.directory:
    - name: {{ pillar['project_logs'] }}
    - makedirs: True
    - user: {{ pillar['user'] }}
    - group: {{ pillar['group'] }}
    - mode: 775

virtualenv-directory:
  file.directory:
    - name: {{ pillar['project_venv'] }}
    - makedirs: True
    - user: {{ pillar['user'] }}
    - group: {{ pillar['group'] }}

conf-directory:
  file.directory:
    - name: {{ pillar['project_conf'] }}
    - makedirs: True
    - user: {{ pillar['user'] }}
    - group: {{ pillar['group'] }}
