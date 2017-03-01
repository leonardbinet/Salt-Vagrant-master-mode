Set secrets file:
  file.managed:
    - name: {{ pillar['project_source'] }}/secret.json
    - template: jinja
    - source: salt://system/secrets.jinga
    # user set is ok for gunicorn, and cron is launched as root so no prob
    - user: {{ pillar['user'] }}
    - group: {{ pillar['group'] }}
    - makedirs: true
    - mode: 777
