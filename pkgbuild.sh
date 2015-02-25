#!/bin/bash

set -u
set -e

pkgname=flasfka
pkgver=1
arch=all
pkgdesc="push/pull on Kafka via http"

version() {
  curl -s https://pypi.python.org/pypi/${pkgname}/json | \
    python -c 'import sys, json; sys.stdout.write(max(json.load(sys.stdin)["releases"].keys()))'
}

prepare() {
  URLVERSION="v$(version | sed 's/\(.\).*$/\1/')"

  rm -rf build
  mkdir -p build/var/www
  mkdir -p build/etc/uwsgi/apps-available
  mkdir -p build/usr/share/doc/${pkgname}-${URLVERSION}
}

build(){
  URLVERSION="v$(version | sed 's/\(.\).*$/\1/')"

  virtualenv -p python2 build/var/www/${pkgname}-${URLVERSION}/venv
  build/var/www/${pkgname}-${URLVERSION}/venv/bin/pip install ${pkgname}

  sed -i "s/URLVERSION/${URLVERSION}/g" postinst
  sed -i "s/URLVERSION/${URLVERSION}/g" prerm
  sed -i "s/URLVERSION/${URLVERSION}/g" uwsgi.ini
  sed -i "s/URLVERSION/${URLVERSION}/g" nginx.conf.sample

  cp uwsgi.ini build/etc/uwsgi/apps-available/${pkgname}-${URLVERSION}.ini
  cp nginx.conf.sample build/usr/share/doc/${pkgname}-${URLVERSION}/nginx.conf.sample

  ln -s venv/bin/${pkgname}-serve \
    build/var/www/${pkgname}-${URLVERSION}/wsgi.py
}


package(){
  VERSION=$(version)
  URLVERSION="v$(version | sed 's/\(.\).*$/\1/')"
  fpm -p ${pkgname}-${URLVERSION}_${VERSION}_${pkgver}_${arch}.deb \
    -n ${pkgname}-${URLVERSION} \
    -v ${VERSION} \
    --iteration ${pkgver} \
    -a ${arch} \
    --description "${pkgdesc}" \
    --post-install postinst \
    --pre-uninstall prerm \
     -d uwsgi  -d uwsgi-plugin-python  \
    -t deb \
    -s dir \
    build/=/
}

echo "Preparing..."
prepare
echo "Building..."
build
echo "Packaging..."
package
