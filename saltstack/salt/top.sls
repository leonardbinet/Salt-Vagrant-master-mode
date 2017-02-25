base:
  '*':
    - system.commons
    - system.python_from_source
    - system.other_python
    - node
    - nginx.ng
    - nginx.ng.config
    - nginx.ng.service
    - website.source_code
    - website.venv_requirements
    - website.secrets
    - website.nginx
    - website.gunicorn
    - website.django
    - website.refresh


#    - user
#    - python
#    - redis
#    - postgresql
#    - website.django
#    - website.wsgiserver
#    - website.webserver
