============
ceph-formula
============

Formulas to set up and configure a Ceph cluster.

.. note::

    See the full `Salt Formulas installation and usage instructions
    <http://docs.saltstack.com/en/latest/topics/development/conventions/formulas.html>`_.

Available states
================

.. contents::
    :local:

``repo``
----------

Configure ceph repository.

``mon``
----------

Install and configure Ceph monitor.

``osd``
----------

Install and configure Ceph OSDs.

For a list of all available options, look at: *ceph/defaults.yaml* - also have a look at the *pillar.example* and *map.jinja*.

Currently tested under:
=======================

* Ubuntu 16.04 LTS
