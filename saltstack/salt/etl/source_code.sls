etl source code:
  git.latest:
    - name: {{ pillar['etl_git_repo'] }}
    - branch: {{ pillar['etl_git_rev'] }}
    - target: {{ pillar['project_source'] }}
    - force_clone: true
    - force_reset: True
