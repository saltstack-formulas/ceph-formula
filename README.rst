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

``ceph``
----------

Install and configure Ceph

``ceph.mon``
----------

Install and configure Ceph monitor.

``ceph.osd``
----------

Install and configure Ceph OSDs.


``ceph.repo``
---------------------

Configures the official Ceph (upstream) repository on target system (either
`download.ceph.org` or `www.suse.com` mirror).

The state relies on ``ceph:use_upstream_repo`` pillar boolean value-

* ``True`` (default): adds the upstream repository to install packages from.
* ``False``: makes sure that the repository configuration is absent.

The ``ceph:release`` pillar controls which release to install. Defaults to ``luminous``.



Usage
========

For a list of all available options, look at: *ceph/defaults.yaml* - also have a look at the *pillar.example* and *map.jinja*.

Supports GNU Linux (Ubuntu, Fedora, Centos, Suse)
