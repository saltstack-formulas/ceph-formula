# -*- coding: utf-8 -*-
# vim: ft=yaml

{% from "ceph/map.jinja" import settings with context -%}

include:
  - ceph.repo

install_ceph_pkgs:
  pkg.installed:
    - pkgs: {{ settings.packages }}

create_ceph_config_file:
  file.touch:
    - name: {{ settings.config.file }}
    - unless: test -e {{ settings.config.file }}

ceph_config_file:
  ini.options_present:
    - name: {{ settings.config.file }}
    - sections:
        global:
          {{ settings.config.global }}

ceph_config_mon_host:
  ini.options_present:
    - name: {{ settings.config.file }}
    - sections:
        global:
          mon_host: {{ settings.mon_hosts|join(', ') }}
