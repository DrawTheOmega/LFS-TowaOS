#!/bin/bash

#CHROOT

cd /sources

echo "Glibc-2.43"
sleep 3
echo "Extrayendo glibc-2.43.tar.xz"
tar -xf glibc-2.43.tar.xz
cd glibc-2.43
patch -Np1 -i ../glibc-fhs-1.patch
mkdir -v build
cd       build
echo "rootsbindir=/usr/sbin" > configparms
../configure --prefix=/usr                   \
             --disable-werror                \
             --disable-nscd                  \
             libc_cv_slibdir=/usr/lib        \
             --enable-stack-protector=strong \
             --enable-kernel=5.4
make
make check

echo 'En caso de fallar algun paquete es recomendado hacer un test. io/tst-lchmod falla si o si por estar en chroot.'
echo 'Con grep "Timed out" $(find -name \*.out) podemos ver bien que pruebas fallaron.'
echo 'Para testear hacer TIMEOUTFACTOR=10 make test t=<test name> (nss/tst-nss-files-hosts-multi por ejemplo)'