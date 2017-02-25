{% from 'settings.sls' import project_name %}
{% from 'settings.sls' import static %}

nginx:
  ng:
    # PPA install
    install_from_ppa: True
    ppa_version: 'stable'
    from_source: False

    service:
      enable: True # Whether or not the service will be enabled/running or dead

    server:
      config:
        worker_processes: 4
        pid: /run/nginx.pid
        events:
          worker_connections: 768
        http:
          sendfile: 'on'
          include:
            - /etc/nginx/mime.types
            - /etc/nginx/conf.d/*.conf
            - /etc/nginx/sites-enabled/*

    servers:
      managed:
        default:
          enabled: false
          config: null

        {{ project_name }}:
          enabled: True
          overwrite: True # overwrite an existing server file or not
          config:
            - server:
              - server_name: {{ project_name }}
              - listen:
                - 80
              - location /static/:
                - root:
                  - {{ static }}
              #- location ~ .htm:
                #- try_files:
                #  - $uri
                #  - $uri/ =404
                #- test: something else
              - location / :
                - proxy_pass: http://127.0.0.1:8887
