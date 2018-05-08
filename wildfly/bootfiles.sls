{% from "wildfly/map.jinja" import wildfly %}

{{ wildfly.service_config }}:
  file.managed:
    - template: jinja
    - source: 
        - salt://wildfly/templates/{{ grains.os }}/service_config.jinja
        - salt://wildfly/templates/{{ grains.os_family }}/service_config.jinja
    - mode: 644
    - user: root
    - group: root
