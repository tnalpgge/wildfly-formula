{% from 'wildfly/map.jinja' import wildfly %}

wildfly_installed:
  test.nop

{% set plan = {'present': [], 'latest': [], 'versioned': [], 'removed': []} %}
{% for package, version in wildfly.packages.iteritems() %}
{%   if version == 'latest' %}
{%     do plan.latest.append(package) %}
{%   elif version in (false, 'absent', 'removed') %}
{%     do plan.removed.append(package) %}
{%   elif version in (true, 'installed', 'present') %}
{%     do plan.present.append(package) %}
{%   else %}
{%     do plan.versioned.append({package: version}) %}
{%   endif %}
{% endfor %}

{% if plan.latest | length %}
wildfly_installed_latest:
  pkg.latest:
    - pkgs: {{ plan.latest }}
    - require_in:
        - test: wildfly_installed
{% endif %}

{% if plan.versioned | length %}
wildfly_installed_versioned:
  pkg.installed:
    - pkgs: {{ plan.versioned }}
    - require_in:
        - test: wildfly_installed
{% endif %}

{% if plan.present | length %}
wildfly_installed_present:
  pkg.installed:
    - pkg: {{ plan.present }}
    - require_in:
        - test: wildfly_installed
{% endif %}

{% if plan.removed | length %}
wildfly_installed_removed:
  pkg.removed:
    - pkgs: {{ plan.removed }}
    - require_in:
        - test: wildfly_installed
{% endif %}
