# -*- coding: utf-8 -*-
# vim: ft=yaml

{% from "ceph/map.jinja" import settings with context -%}

{% for osd_device in settings.osds.active %}
prepare_osd_device_{{ osd_device }}:
  cmd.run:
    - name: 'ceph-disk prepare {{ osd_device }}'
    - unless: "ceph-disk list | grep -E ' *{{ osd_device }}1? .*ceph data, (prepared|active)'"
{% endfor %}
