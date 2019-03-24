# -*- coding: utf-8 -*-
# vim: ft=yaml

{% from "ceph/map.jinja" import ceph with context -%}

{% set mon_name = grains['host'] %}
{% set mon_dir = '/var/lib/ceph/mon/' ~ ceph.cluster_name ~ '-' ~ mon_name %}

mkdir_dir_for_{{ mon_name }}:
  file.directory:
    - name: {{ mon_dir }}
    - user: ceph
    - group: ceph

add_mon_{{ mon_name }}:
  cmd.run:
    - name: "ceph-mon --cluster {{ ceph.cluster_name }} --setuser ceph --setgroup ceph --mkfs --id {{ mon_name }} --keyring /dev/null"
    - unless: 'test -d {{ mon_dir }}/store.db'

start_mon_service_for_{{ mon_name }}:
  service.running:
     - name: ceph-mon@{{ mon_name }}
     - enable: True
