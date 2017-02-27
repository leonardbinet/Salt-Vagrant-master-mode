#include:
#  - system.python_from_source

other_python:
  pkg.installed:
    - names:
      # Python: works for 3.4, but doesn't work for 3.5
      # - python3
      - python3-dev # those two might not be necessary
      - python3-pip #
      - python-virtualenv
#    - require:
#      - python-install
