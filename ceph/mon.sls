# -*- coding: utf-8 -*-
# vim: ft=yaml

{% from "ceph/map.jinja" import settings with context -%}

{% set mon_name = 'mymon' %}
{% set mon_dir = salt['cmd.run']('ceph-mon  --id ' ~ mon_name ~ ' --show-config-value mon_data') %}

mkdir_dir_for_{{ mon_name }}:
  file.directory:
    - name: {{ mon_dir }}
    - user: ceph
    - group: ceph

add_mon_{{ mon_name }}:
  cmd.run:
    - name: "ceph-mon --setuser ceph --setgroup ceph --mkfs --id {{ mon_name }} --keyring /dev/null"
    - unless: 'test -d {{ mon_dir }}/store.db'

start_mon_service_for_{{ mon_name }}:
  service.running:
     - name: ceph-mon@{{ mon_name }}
