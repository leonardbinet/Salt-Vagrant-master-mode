commons:
  pkg.installed:
    - names:
      - git
      - wget # to download
      # all of this, might be necessary to build python and libraries
      - make
      - build-essential
      - ntp # to get right system time and avoid boto signature error
      - libssl-dev
      - openssl
      - llvm
      - libpq-dev
      - zlib1g-dev
      - libbz2-dev
      - libreadline-dev
      - libsqlite3-dev
      # tinker: for matplotlib
      - python3-tk

ntp_service restart:
  module.run:
    - name: service.restart
    - m_name: ntp
