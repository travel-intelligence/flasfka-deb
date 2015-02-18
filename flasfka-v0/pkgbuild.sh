#!/bin/bash
#
# Build script for flasfka-v0. We rely on the fact the repo contains
# "requirements.txt", since 'pip -r requirements.txt' is used to set up
# the virtualenv.
#
# To serve with nginx:
#
#    location = /flasfka/v0 { rewrite ^ /flasfka/v0/; }
#
#    location /flasfka/v0 { try_files $uri @flasfka-v0; }
#
#    location @flasfka-v0 {
#        include uwsgi_params;
#        uwsgi_param SCRIPT_NAME /flasfka/v0;
#        uwsgi_modifier1 30;
#        uwsgi_pass unix:/var/run/uwsgi/app/flasfka-v0/socket;
#    }
#

set -u
set -e

source=https://github.com/travel-intelligence/flasfka.git
pkgname=flasfka-v0
pkgver=1
arch=all
pkgdesc="Flask app to talk to Kafka, served with uwsgi"

## When versions are tagged (prefered)
#version() {
#  cd src/ >/dev/null
#  git describe --long | sed -r 's/([^-]*-g)/r\1/;s/-/./g'
#  cd - >/dev/null
#}

# When there is no tag
version() {
  cd src/ >/dev/null
  printf "%s.%s" "$(git rev-list --count HEAD)" "$(git rev-parse --short HEAD)"
  cd - >/dev/null
}

prepare() {
  rm -rf build src
  mkdir -p build/var/www
  mkdir -p build/etc/uwsgi/apps-available
  git clone ${source} src
}

build(){
  virtualenv -p python2 build/var/www/${pkgname}/venv
  cd src
  ../build/var/www/${pkgname}/venv/bin/pip install -r requirements.txt
  cd -
  cp -R src/* build/var/www/${pkgname}
  cp uwsgi.ini build/etc/uwsgi/apps-available/${pkgname}.ini
}

package(){
  VERSION=$(version)
  fpm -p ${pkgname}_${VERSION}_${pkgver}_${arch}.deb \
    -n ${pkgname} \
    -v ${VERSION} \
    --iteration ${pkgver} \
    -a ${arch} \
    --description "${pkgdesc}" \
    --post-install postinst \
    --pre-uninstall prerm \
    --post-uninstall postrm \
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