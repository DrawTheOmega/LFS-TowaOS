#!/bin/bash

#LFS

cd $LFS/sources/

echo "Binutils-2.46.0 - Pass 1"
sleep 3
echo "Extrayendo binutils-2.46.0.tar.xz"
tar -xf binutils-2.46.0.tar.xz
cd binutils-2.46.0
mkdir -v build
cd build
../configure --prefix=$LFS/tools \
             --with-sysroot=$LFS \
             --target=$LFS_TGT   \
             --disable-nls       \
             --enable-gprofng=no \
             --disable-werror    \
             --enable-new-dtags  \
             --enable-default-hash-style=gnu
make
make install
cd $LFS/sources/
rm -rf binutils-2.46.0

echo "GCC-15.2.0 - Pass 1"
sleep 3
echo "Extrayendo gcc-15.2.0.tar.xz"
tar -xf gcc-15.2.0.tar.xz
cd gcc-15.2.0
tar -xf ../mpfr-4.2.2.tar.xz
mv -v mpfr-4.2.2 mpfr
tar -xf ../gmp-6.3.0.tar.xz
mv -v gmp-6.3.0 gmp
tar -xf ../mpc-1.3.1.tar.gz
mv -v mpc-1.3.1 mpc
case $(uname -m) in
  x86_64)
    sed -e '/m64=/s/lib64/lib/' \
        -i.orig gcc/config/i386/t-linux64
 ;;
esac
mkdir -v build
cd       build
../configure                  \
    --target=$LFS_TGT         \
    --prefix=$LFS/tools       \
    --with-glibc-version=2.43 \
    --with-sysroot=$LFS       \
    --with-newlib             \
    --without-headers         \
    --enable-default-pie      \
    --enable-default-ssp      \
    --disable-nls             \
    --disable-shared          \
    --disable-multilib        \
    --disable-threads         \
    --disable-libatomic       \
    --disable-libgomp         \
    --disable-libquadmath     \
    --disable-libssp          \
    --disable-libvtv          \
    --disable-libstdcxx       \
    --enable-languages=c,c++
make
make install
cd ..
cat gcc/limitx.h gcc/glimits.h gcc/limity.h > \
  `dirname $($LFS_TGT-gcc -print-libgcc-file-name)`/include/limits.h
cd $LFS/sources/
rm -rf gcc-15.2.0

echo "Linux-6.18.10 API Headers"
sleep 3
echo "Extrayendo linux-6.18.10.tar.xz"
tar -xf linux-6.18.10.tar.xz
cd linux-6.18.10
make mrproper
make headers
find usr/include -type f ! -name '*.h' -delete
cp -rv usr/include $LFS/usr
cd $LFS/sources/
rm -rf linux-6.18.10

echo "Glibc-2.43"
sleep 3
echo "Extrayendo glibc-2.43.tar.xz"
tar -xf glibc-2.43.tar.xz
cd glibc-2.43
case $(uname -m) in
    i?86)   ln -sfv ld-linux.so.2 $LFS/lib/ld-lsb.so.3
    ;;
    x86_64) ln -sfv ../lib/ld-linux-x86-64.so.2 $LFS/lib64
            ln -sfv ../lib/ld-linux-x86-64.so.2 $LFS/lib64/ld-lsb-x86-64.so.3
    ;;
esac
patch -Np1 -i ../glibc-fhs-1.patch
mkdir -v build
cd       build
echo "rootsbindir=/usr/sbin" > configparms
../configure                             \
      --prefix=/usr                      \
      --host=$LFS_TGT                    \
      --build=$(../scripts/config.guess) \
      --disable-nscd                     \
      libc_cv_slibdir=/usr/lib           \
      --enable-kernel=5.4
make
make DESTDIR=$LFS install
sed '/RTLDLIST=/s@/usr@@g' -i $LFS/usr/bin/ldd
echo 'int main(){}' | $LFS_TGT-gcc -x c - -v -Wl,--verbose &> dummy.log
readelf -l a.out | grep ': /lib'
sleep 3
grep -E -o "$LFS/lib.*/S?crt[1in].*succeeded" dummy.log
sleep 3
grep -B3 "^ $LFS/usr/include" dummy.log
sleep 3
grep 'SEARCH.*/usr/lib' dummy.log |sed 's|; |\n|g'
sleep 3
grep "/lib.*/libc.so.6 " dummy.log
sleep 3
grep found dummy.log
sleep 3
rm -v a.out dummy.log
cd $LFS/sources/
rm -rf glibc-2.43

echo "Libstdc++ from GCC-15.2.0"
sleep 3
echo "Extrayendo gcc-15.2.0.tar.xz"
tar -xf gcc-15.2.0.tar.xz
cd gcc-15.2.0
mkdir -v build
cd       build
../libstdc++-v3/configure      \
    --host=$LFS_TGT            \
    --build=$(../config.guess) \
    --prefix=/usr              \
    --disable-multilib         \
    --disable-nls              \
    --disable-libstdcxx-pch    \
    --with-gxx-include-dir=/tools/$LFS_TGT/include/c++/15.2.0
make
make DESTDIR=$LFS install
rm -v $LFS/usr/lib/lib{stdc++{,exp,fs},supc++}.la
cd $LFS/sources/
rm -rf gcc-15.2.0

echo "Fin del compilado del Cross-Toolchain"
sleep 3
