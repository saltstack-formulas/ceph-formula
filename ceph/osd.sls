# -*- coding: utf-8 -*-
# vim: ft=yaml

{% from "ceph/map.jinja" import settings with context -%}

{% for osd_device in settings.osds.active %}

zap_disk_{{ osd_device }}:
  cmd.run:
    - name: 'ceph-disk zap {{ osd_device }}'
    - unless: "ceph-disk list | grep -E ' *{{ osd_device }}1? .*ceph data, (prepared|active)'"

prepare_osd_device_{{ osd_device }}:
  cmd.run:
    - name: 'ceph-disk prepare {{ osd_device }}'
    - unless: "ceph-disk list | grep -E ' *{{ osd_device }}1? .*ceph data, (prepared|active)'"

{% endfor %}

{% for removed_osd in settings.osds.removed %}
  {% set osd_id = salt['cmd.run']("ceph-disk list | grep '" ~ removed_osd ~ "1 ceph' | awk -F'[.,]' '{print $5}'") %}

osd_out_{{ removed_osd }}:
  cmd.run:
    - name: 'ceph osd out {{ osd_id }}'
    - unless: "ceph-disk list | grep -E ' *{{ removed_osd }}1? .*ceph data, unprepared'"

stop_service_{{ removed_osd }}:
  service.dead:
    - name: ceph-osd@{{ osd_id }}
    - unless: "ceph-disk list | grep -E ' *{{ removed_osd }}1? .*ceph data, unprepared'"

crush_remove_{{ removed_osd }}:
  cmd.run:
    - name: 'ceph osd crush remove osd.{{ osd_id }}'
    - unless: "ceph-disk list | grep -E ' *{{ removed_osd }}1? .*ceph data, unprepared'"

auth_del_{{ removed_osd }}:
  cmd.run:
    - name: 'ceph auth del osd.{{ osd_id }}'
    - unless: "ceph-disk list | grep -E ' *{{ removed_osd }}1? .*ceph data, unprepared'"

osd_rm_{{ removed_osd }}:
  cmd.run:
    - name: 'ceph osd rm {{ osd_id }}'
    - unless: "ceph-disk list | grep -E ' *{{ removed_osd }}1? .*ceph data, unprepared'"

rm_umount_rm_{{ removed_osd }}:
  cmd.run:
    - name: 'rm -fr /var/lib/ceph/osd/ceph-{{ osd_id }}/* &&
      umount /var/lib/ceph/osd/ceph-{{ osd_id }} &&
      rm -fr /var/lib/ceph/osd/ceph-{{ osd_id }}'
    - unless: "ceph-disk list | grep -E ' *{{ removed_osd }}1? .*ceph data, unprepared'"

{% endfor %}
