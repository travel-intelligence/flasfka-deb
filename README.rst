flasfka-deb
===========

|Build Status|

Packaging for flasfka (fpm-based)

What
----

This will create a debian package from the latest pypi release.

Features
--------

The package embeds all the python dependencies in a virtualenv. It also
sets up uwsgi and suggests an nginx config at install time. An example
configuration for nginx is attached.

Naming convention
-----------------

The package is named ``flasfka-v0`` (or ``flasfka-v1``, or
``flasfka-v2``... depending on the release name). It is meant to be served
from ``/flasfka/v0`` (or ``/flasfka/v1``, or ``/flasfka/v2``...).

This is for upgrade purpose, such that 2 incompatible versions can be
installed on the same system without apt complaining.

flaskfka has `semantic versioning <http://semver.org>`_, which guarantees
that versions starting with the same digit (MAJOR) have a backward
compatible api. As a consequence, this digit determines the name of the
package (``0.x.y`` generates ``flasfka-v0``, ``1.x.y`` generates
``flasfka-v1``...), ensuring that we can safely replace the packages of a
same MAJOR with one another.

How to build
============

- install fpm
- run ``sh pkgbuild.sh``

.. |Build Status| image:: https://travis-ci.org/travel-intelligence/flasfka-deb.svg?branch=master
    :target: https://travis-ci.org/travel-intelligence/flasfka-deb
