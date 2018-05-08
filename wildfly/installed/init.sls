{% from "wildfly/map.jinja" import wildfly %}
include:
  - wildfly.installed.{{ wildfly.install_type }}
