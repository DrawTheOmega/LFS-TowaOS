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

echo "Xz-5.8.2"
sleep 3
echo "Extrayendo xz-5.8.2.tar.xz"
tar -xf xz-5.8.2.tar.xz
cd xz-5.8.2
./configure --prefix=/usr    \
            --disable-static \
            --docdir=/usr/share/doc/xz-5.8.2
make
make check
make install
cd /sources
rm -rf xz-5.8.2

echo "Lz4-1.10.0"
sleep 3
echo "Extrayendo lz4-1.10.0.tar.gz"
tar -xf lz4-1.10.0.tar.gz
cd lz4-1.10.0
make BUILD_STATIC=no PREFIX=/usr
make -j1 check
make BUILD_STATIC=no PREFIX=/usr install
cd /sources
rm -rf lz4-1.10.0

echo "Zstd-1.5.7"
sleep 3
echo "Extrayendo zstd-1.5.7.tar.gz"
tar -xf zstd-1.5.7.tar.gz
cd zstd-1.5.7
make prefix=/usr
make check
make prefix=/usr install
rm -v /usr/lib/libzstd.a

echo "File-5.46"
sleep 3
echo "Extrayendo file-5.46.tar.gz"
tar -xf file-5.46.tar.gz
cd file-5.46
./configure --prefix=/usr
make
make check
make install
cd /sources
rm -rf file-5.46

echo "Readline-8.3"
sleep 3
echo "Extrayendo readline-8.3.tar.gz"
tar -xf readline-8.3.tar.gz
cd readline-8.3
sed -i '/MV.*old/d' Makefile.in
sed -i '/{OLDSUFF}/c:' support/shlib-install
sed -i 's/-Wl,-rpath,[^ ]*//' support/shobj-conf
sed -e '270a\
     else\
       chars_avail = 1;'      \
    -e '288i\   result = -1;' \
    -i.orig input.c
./configure --prefix=/usr    \
            --disable-static \
            --with-curses    \
            --docdir=/usr/share/doc/readline-8.3
make SHLIB_LIBS="-lncursesw"
make install
install -v -m644 doc/*.{ps,pdf,html,dvi} /usr/share/doc/readline-8.3
