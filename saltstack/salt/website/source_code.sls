project-directory:
  file.directory:
    - name: /home/ubuntu/sites/{{ pillar['project_name'] }}
    - makedirs: True
    - user: {{ pillar['user'] }}
    - group: {{ pillar['group'] }}


source-directory:
  file.directory:
    - name: /home/ubuntu/sites/{{ pillar['project_name'] }}/source
    - makedirs: True
    - user: {{ pillar['user'] }}
    - group: {{ pillar['group'] }}


logs-directory:
  file.directory:
    - name: /home/ubuntu/sites/{{ pillar['project_name'] }}/logs
    - makedirs: True
    - user: {{ pillar['user'] }}
    - group: {{ pillar['group'] }}
    - mode: 775

virtualenv-directory:
  file.directory:
    - name: /home/ubuntu/sites/{{ pillar['project_name'] }}/virtualenv
    - makedirs: True
    - user: {{ pillar['user'] }}
    - group: {{ pillar['group'] }}

website source code:
  git.latest:
    - name: {{ pillar['git_repo'] }}
    - branch: master
    - target: /home/ubuntu/sites/{{ pillar['project_name'] }}/source
    #- require:
    #  - project-directory
