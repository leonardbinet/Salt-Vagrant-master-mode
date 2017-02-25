{% from 'settings.sls' import wsgi_app_loc %}
gunicorn:
  wsgi_app_loc: {{ wsgi_app_loc }}
