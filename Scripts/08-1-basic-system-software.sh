#!/bin/bash

#CHROOT

cd /sources

echo "Man-pages-6.17"
sleep 3
echo "Extrayendo man-pages-6.17.tar.xz"
tar -xf man-pages-6.17.tar.xz
cd man-pages-6.17
rm -v man3/crypt*
make -R GIT=false prefix=/usr install
cd /sources
rm -rf man-pages-6.17

echo "Iana-Etc-20260202"
sleep 3
echo "Extrayendo iana-etc-20260202.tar.gz"
tar -xf iana-etc-20260202.tar.gz
cd iana-etc-20260202
cp -v services protocols /etc
cd /sources
rm -rf iana-etc-20260202