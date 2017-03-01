base:
  '*':
    - system.commons
    # On AWS AMI, python 3.5 already installed
    # - system.python_from_source:
    - system.other_python
    - system.secrets_file

  'minion_website':
    - node
    - nginx.ng
    - nginx.ng.config
    - nginx.ng.service
    - website.directory
    - website.source_code
    - website.venv_requirements
#   - website.secrets
    - website.nginx
    - website.gunicorn
    - website.django
    - website.refresh

  'minion_etl':
    - etl.source_code
    - etl.directory
    - etl.jenkins
    - etl.venv_requirements

    #- nginx.ng
    #- nginx.ng.config
    #- nginx.ng.service
    #- etl.nginx
    #- jenkins.nginx

    # need to provide secrets through env variables
