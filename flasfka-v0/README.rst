What
====

This will create a package from flasfka master branch.

The package embeds all the python dependencies in a virtualenv. It also
sets up uwsgi. An example configuration for nginx is given at the top of
the file pkgbuild.sh.

The package created is named ``flasfka-v0``, and is meant to be served
from the url ``/flasfka/v0/``. This is for upgrade purpose, so that future
versions, should they be incompatible, can be installed as e.g.
``flasfka-v1`` and served from ``/flasfka/v1/``, without apt complaining.

How to build
============

- install fpm
- run ``sh pkgbuild.sh``
