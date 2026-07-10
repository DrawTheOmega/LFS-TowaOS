#!/bin/bash

#CHROOT

cd /sources

echo "Zlib-1.3.2"
sleep 3
echo "Extrayendo zlib-1.3.2.tar.xz"
tar -xf zlib-1.3.2.tar.xz
cd zlib-1.3.2
./configure --prefix=/usr
make
make check
make install
rm -fv /usr/lib/libz.a
cd /sources
rm -rf zlib-1.3.2

echo "Bzip2-1.0.8"
sleep 3
echo "Extrayendo bzip2-1.0.8.tar.gz"
tar -xf bzip2-1.0.8.tar.gz
cd bzip2-1.0.8
patch -Np1 -i ../bzip2-1.0.8-install_docs-1.patch
sed -i 's@\(ln -s -f \)$(PREFIX)/bin/@\1@' Makefile
sed -i "s@(PREFIX)/man@(PREFIX)/share/man@g" Makefile
make -f Makefile-libbz2_so
make clean
make
make PREFIX=/usr install
cp -av libbz2.so.* /usr/lib
ln -sfv libbz2.so.1.0.8 /usr/lib/libbz2.so
ln -sfv libbz2.so.1.0.8 /usr/lib/libbz2.so.1
cp -v bzip2-shared /usr/bin/bzip2
for i in /usr/bin/{bzcat,bunzip2}; do
  ln -sfv bzip2 $i
done
rm -fv /usr/lib/libbz2.a
cd /sources
rm -rf bzip2-1.0.8