{% set secrets = pillar.get('secrets', {}) -%}

{% for key, value in secrets.items() -%}
{{ key }}_environment_variable_venv:
  file.append:
    - name: {{ pillar['project_venv'] }}/bin/activate #
    - text: export {{ key }}="{{ value }}"

{% endfor -%}

# /home/ubuntu/.bashrc
# /etc/profile.d/myglobalenvvariables.sh


{% for key, value in secrets.items() -%}
{{ key }}_global_environment:
   environ.setenv:
     - name: {{ key }}
     - value: {{ value }}
     - update_minion: True
{% endfor -%}


secrets file:
  file.managed:
    - name: {{ pillar['project_source'] }}/secret.json
    #- template: jinja
    - source: salt://secret.json
    - user: {{ pillar['user'] }}
    - group: {{ pillar['group'] }}
