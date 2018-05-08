{% from 'wildfly/map.jinja' import wildfly %}
{% set extracted_dir = wildfly.unzip_path ~ '/wildfly-' ~ wildfly.version %}

wildfly_installed:
  test.nop

wildfly_group:
  group.present:
    - gid: {{ wildfly.wildfly_gid }}
    - name: {{ wildfly.wildfly_group }}
    - require_in:
        - test: wildfly_installed

wildfly_user:
  user.present:
    - createhome: False
    - fullname: WildFly service user
    - name: {{ wildfly.wildfly_user }}
    - uid: {{ wildfly.wildfly_uid }}
    - gid: {{ wildfly.wildfly_gid }}
    - require:
        - group: wildfly_group
    - require_in:
        - test: wildfly_installed

wildfly_extracted:
  archive.extracted:
    - archive_format: zip
    - name: {{ wildfly.unzip_path }}
    - user: {{ wildfly.wildfly_user }}
    - group: {{ wildfly.wildfly_group }}
    - keep: True
    - name: {{ wildfly.unzip_path }}
    - source: {{ wildfly.download | replace('VERSION', wildfly.version) }}
    - source_hash: md5={{ wildfly.versions[wildfly.version].md5 }}
    - require_in:
        - test: wildfly_installed

wildfly_symlink:
  file.symlink:
    - name: {{ wildfly.wildfly_home }}
    - target: {{ extracted_dir }}
    - force: True
    - backupname: {{ wildfly.wildfly_home }}.bak
    - makedirs: True
    - user: {{ wildfly.wildfly_user }}
    - group: {{ wildfly.wildfly_group }}
    - mode: 0755
    - require:
        - archive: wildfly_extracted
    - require_in:
        - test: wildfly_installed

wildfly_ownership:
  file.directory:
    - name: {{ extracted_dir }}
    - user: {{ wildfly.wildfly_user }}
    - group: {{ wildfly.wildfly_group }}
    - recurse:
        - user
        - group
    - require:
        - archive: wildfly_extracted
    - require_in:
        - test: wildfly_installed

wildfly_bin_dir:
  file.directory:
    - name: {{ extracted_dir }}/bin
    - file_mode: 755
    - recurse:
        - mode
    - require:
        - archive: wildfly_extracted
    - require_in:
        - test: wildfly_installed

wildfly_log_dir:
  file.directory:
    - name: {{ wildfly.log_dir }}/{{ wildfly.wildfly_mode }}
    - user: {{ wildfly.wildfly_user }}
    - group: {{ wildfly.wildfly_group }}
    - makedirs: True
    - dir_mode: 755
    - require_in:
        - test: wildfly_installed

# e.g. /etc/default/wildfly.conf, /etc/sysconfig/wildfly
#wildfly_service_config:
#  file.managed

#wildfly_service_script:
#  file.managed
