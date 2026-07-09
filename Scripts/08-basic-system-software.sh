#!/bin/bash

cd /sources

echo "Man-pages-6.17"
sleep 3
tar -xf man-pages-6.17.tar.xz
cd man-pages-6.17
rm -v man3/crypt*
make -R GIT=false prefix=/usr install
cd /sources
rm -rf man-pages-6.17