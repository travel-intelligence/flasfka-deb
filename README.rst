flasfka-deb
===========

|Build Status|

Packaging for flasfka (fpm-based) based on the latest pypi release.

Features
--------

The package embeds all the python dependencies in a virtualenv. It also
sets up uwsgi. An example configuration for nginx is included in the
package.

How to build
------------

- install fpm
- install python-virtualenv
- run ``sh pkgbuild.sh``

How to use, once built and installed
------------------------------------

- copy ``/usr/share/doc/flasfka-*/nginx.conf.sample`` to ``/etc/nginx.conf``,
  restart nginx.
- post/get to/from ``/flasfka/vX`` (where ``X`` is the major version - see
  below)

Package naming convention
-------------------------

flaskfka has `semantic versioning <http://semver.org>`_, which guarantees
that versions starting with the same digit (MAJOR) have a backward
compatible api. This digit determines the name of the package (``0.x.y``
generates ``flasfka-v0``, ``1.x.y`` generates ``flasfka-v1``...), ensuring
that we can safely replace the packages of a same MAJOR with one another.

This is for upgrade purpose, such that 2 incompatible versions can be
installed on the same system, and served at 2 urls, without apt
complaining.


.. |Build Status| image:: https://travis-ci.org/travel-intelligence/flasfka-deb.svg?branch=master
    :target: https://travis-ci.org/travel-intelligence/flasfka-deb
