# -*- coding: utf-8 -*-
# vim: ft=yaml

{% from "ceph/map.jinja" import ceph with context -%}

include:
  - ceph.repo

install_ceph_pkgs:
  pkg.installed:
    - pkgs: {{ ceph.packages|tojson }}

create_ceph_config_file:
  file.touch:
    - name: {{ ceph.config.file }}
    - unless: test -e {{ ceph.config.file }}

ceph_config_file:
  ini.options_present:
    - name: {{ ceph.config.file }}
    - sections:
        global:
          {{ ceph.config.global | json }}

ceph_config_mon_host:
  ini.options_present:
    - name: {{ ceph.config.file }}
    - sections:
        global:
          mon_host: {{ ceph.mon_hosts|join(', ') }}
