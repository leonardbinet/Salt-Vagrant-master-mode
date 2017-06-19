{% set secrets = pillar.get('secrets', {}) -%}

# Set secrets in python virtualenv activate script
{% for key, value in secrets.items() -%}
{{ key }}_environment_variable_venv:
  file.append:
    - name: {{ pillar['project_venv'] }}/bin/activate
    - text: export {{ key }}="{{ value }}"

{% endfor -%}

# Set secrets in salt process global environment variable
{% for key, value in secrets.items() -%}
{{ key }}_global_environment:
   environ.setenv:
     - name: {{ key }}
     - value: {{ value }}
     - update_minion: True
{% endfor -%}


Set lib secrets file:
  file.managed:
    - name: {{ pillar['project_source'] }}/lib/secret.json
    - template: jinja
    - source: salt://system/secrets.jinga
    # user set is ok for gunicorn, and cron is launched as root so no prob
    - user: {{ pillar['user'] }}
    - group: {{ pillar['group'] }}
    - makedirs: true
    - mode: 777
