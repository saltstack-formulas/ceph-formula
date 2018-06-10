# -*- coding: utf-8 -*-
# vim: ft=jinja

{%- from 'ceph/map.jinja' import ceph with context -%}
{%- from tpldir + "/macros.jinja" import format_kwargs with context -%}

{% if 'pkg_repo' in ceph %}
  {% if ceph.use_upstream_repo == true %}

# Add upstream repository for your distro
ceph-repo:
  pkgrepo.managed:
    {{- format_kwargs(ceph.pkg_repo) }}

  {%- else -%}

# Remove repo configuration (and GnuPG key)
ceph-repo:
  pkgrepo.absent:
    - name: {{ ceph.pkg_repo.name }}
    {%- if 'pkg_repo_keyid' in ceph %}
    - keyid: {{ ceph.pkg_repo_keyid }}
    {%- endif %}

  {%- endif -%}
{%- elif grains.os not in ('Windows', 'MacOS',) %}

ceph-repo:
  test.show_notification:
    - text: |
        Ceph does not provide package repository for {{ grains['osfinger'] }}

{%- endif %}
