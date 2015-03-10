#!/bin/bash

set -u
set -e

pkgname=flasfka
pkgver=2
arch=all
pkgdesc="push/pull on Kafka via http"

# What is the latest version, according to pypi?
VERSION=$(curl -s https://pypi.python.org/pypi/${pkgname}/json \
  | python -c 'import sys, json; sys.stdout.write(max(json.load(sys.stdin)["releases"].keys()))')
# First digit of the version
URLVERSION="v$(echo ${VERSION} | sed 's/\(.\).*$/\1/')"

prepare() {
  rm -rf build
  mkdir -p build/var/www
  mkdir -p build/etc/uwsgi/apps-available
  mkdir -p build/usr/share/doc/${pkgname}-${URLVERSION}
}

build(){
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
