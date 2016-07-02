# -*- coding: utf-8 -*-
# vim: ft=yaml

{% from "ceph/map.jinja" import settings with context -%}

{%- if grains['os_family'] == 'Debian' %}
ceph-repo:
  pkgrepo.managed:
    - humanname: Ceph Debian Repository
    - name: deb http://download.ceph.com/debian-{{ settings.release }}/ {{ grains.oscodename }} main
    - key_url: https://download.ceph.com/keys/release.asc
{%- endif %}
