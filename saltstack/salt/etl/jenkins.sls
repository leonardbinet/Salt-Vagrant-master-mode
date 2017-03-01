jenkins user:
  user.present:
    - name: jenkins
    - empty_password: true
    - groups:
      - www-data
      - sudo

jenkins commands:
  cmd.run:
    - name: "wget -q -O - https://pkg.jenkins.io/debian/jenkins-ci.org.key | sudo apt-key add - && sh -c 'echo deb http://pkg.jenkins.io/debian-stable binary/ > /etc/apt/sources.list.d/jenkins.list' && apt-get update"

jenkins install:
  pkg.installed:
    - name: jenkins
