etl source code:
  git.latest:
    - name: {{ pillar['website_git_repo'] }}
    - branch: {{ pillar['website_git_rev'] }}
    - target: {{ pillar['project_source'] }}
    - force_reset: True
