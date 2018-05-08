include:
  - wildfly.installed
  - wildfly.bootfiles

{% from "wildfly/map.jinja" import wildfly %}

{{ wildfly.service }}:
  service.running:
    - enable: True
