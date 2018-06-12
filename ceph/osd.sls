# -*- coding: utf-8 -*-
# vim: ft=yaml

{% from "ceph/map.jinja" import ceph with context -%}

{% for active_osd in ceph.osds.active %}
    {% set osd_params = active_osd.split(':') %}
    {% set data_path = osd_params[0] %}
    {% if osd_params|length == 2 %}
        {% set journal_path = osd_params[1] %}
    {% else %}
        {% set journal_path = '' %}
    {% endif %}

zap_disk_{{ data_path }}:
  cmd.run:
    - name: 'ceph-disk zap {{ data_path }}'
    - unless: "ceph-disk list | grep -E ' *{{ data_path }}1? .*ceph data, (prepared|active)'"

prepare_osd_device_{{ data_path }}:
  cmd.run:
    - name: 'ceph-disk prepare --cluster {{ ceph.cluster_name }} {{ data_path }} {{ journal_path }}'
    - unless: "ceph-disk list | grep -E ' *{{ data_path }}1? .*ceph data, (prepared|active)'"

{% endfor %}

{% for removed_osd in ceph.osds.removed %}
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
    - name: 'ceph --cluster {{ ceph.cluster_name }} osd crush remove osd.{{ osd_id }}'
    - unless: "ceph-disk list | grep -E ' *{{ removed_osd }}1? .*ceph data, unprepared'"

auth_del_{{ removed_osd }}:
  cmd.run:
    - name: 'ceph --cluster {{ ceph.cluster_name }} auth del osd.{{ osd_id }}'
    - unless: "ceph-disk list | grep -E ' *{{ removed_osd }}1? .*ceph data, unprepared'"

osd_rm_{{ removed_osd }}:
  cmd.run:
    - name: 'ceph --cluster {{ ceph.cluster_name }} osd rm {{ osd_id }}'
    - unless: "ceph-disk list | grep -E ' *{{ removed_osd }}1? .*ceph data, unprepared'"

rm_umount_rm_{{ removed_osd }}:
  cmd.run:
    - name: 'rm -fr /var/lib/ceph/osd/{{ ceph.cluster_name }}-{{ osd_id }}/* &&
      umount /var/lib/ceph/osd/{{ ceph.cluster_name }}-{{ osd_id }} &&
      rm -fr /var/lib/ceph/osd/{{ ceph.cluster_name }}-{{ osd_id }}'
    - unless: "ceph-disk list | grep -E ' *{{ removed_osd }}1? .*ceph data, unprepared'"

{% endfor %}
