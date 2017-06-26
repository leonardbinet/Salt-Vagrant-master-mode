celerybeat_service restart:
  module.run:
    - name: service.restart
    - m_name: celerybeat

celery_service restart:
  module.run:
    - name: service.restart
    - m_name: celery

celeryflower_service restart:
  module.run:
    - name: service.restart
    - m_name: celeryflower