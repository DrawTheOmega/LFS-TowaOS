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
cd /sources
rm -rf readline-8.3

echo "Pcre2-10.47"
sleep 3
echo "Extrayendo pcre2-10.47.tar.gz"
tar -xf pcre2-10.47.tar.bz2
cd pcre2-10.47
./configure --prefix=/usr                       \
            --docdir=/usr/share/doc/pcre2-10.47 \
            --enable-unicode                    \
            --enable-jit                        \
            --enable-pcre2-16                   \
            --enable-pcre2-32                   \
            --enable-pcre2grep-libz             \
            --enable-pcre2grep-libbz2           \
            --enable-pcre2test-libreadline      \
            --disable-static
make
make check
make install
cd /sources
rm -rf pcre2-10.47

echo "M4-1.4.21"
sleep 3
echo "Extrayendo m4-1.4.21.tar.xz"
tar -xf m4-1.4.21.tar.xz
cd m4-1.4.21
./configure --prefix=/usr
make
make check
make install
cd /sources
rm -rf m4-1.4.21

echo "Bc-5.3.2"
sleep 3
echo "Extrayendo bc-5.3.2.tar.xz"
tar -xf bc-5.3.2.tar.xz
cd bc-5.3.2
CC='gcc -std=c99' ./configure --prefix=/usr -G -O3 -r
make
make test
make install
cd /sources
rm -rf bc-5.3.2

echo "Flex-2.6.4"
sleep 3
echo "Extrayendo flex-2.6.4.tar.gz"
tar -xf flex-2.6.4.tar.gz
cd flex-2.6.4
./configure --prefix=/usr    \
            --disable-static \
            --docdir=/usr/share/doc/flex-2.6.4
make
make check
make install
ln -sv flex   /usr/bin/lex
ln -sv flex.1 /usr/share/man/man1/lex.1
cd /sources
rm -rf flex-2.6.4

echo "Tcl-8.6.17"
sleep 3
echo "Extrayendo tcl8.6.17-src.tar.gz"
tar -xf tcl8.6.17-src.tar.gz
cd tcl8.6.17
SRCDIR=$(pwd)
cd unix
./configure --prefix=/usr           \
            --mandir=/usr/share/man \
            --disable-rpath
make
sed -e "s|$SRCDIR/unix|/usr/lib|" \
    -e "s|$SRCDIR|/usr/include|"  \
    -i tclConfig.sh
sed -e "s|$SRCDIR/unix/pkgs/tdbc1.1.12|/usr/lib/tdbc1.1.12|" \
    -e "s|$SRCDIR/pkgs/tdbc1.1.12/generic|/usr/include|"     \
    -e "s|$SRCDIR/pkgs/tdbc1.1.12/library|/usr/lib/tcl8.6|"  \
    -e "s|$SRCDIR/pkgs/tdbc1.1.12|/usr/include|"             \
    -i pkgs/tdbc1.1.12/tdbcConfig.sh
sed -e "s|$SRCDIR/unix/pkgs/itcl4.3.4|/usr/lib/itcl4.3.4|" \
    -e "s|$SRCDIR/pkgs/itcl4.3.4/generic|/usr/include|"    \
    -e "s|$SRCDIR/pkgs/itcl4.3.4|/usr/include|"            \
    -i pkgs/itcl4.3.4/itclConfig.sh
unset SRCDIR
LC_ALL=C.UTF-8 make test
make install 
chmod 644 /usr/lib/libtclstub8.6.a
chmod -v u+w /usr/lib/libtcl8.6.so
make install-private-headers
ln -sfv tclsh8.6 /usr/bin/tclsh
mv -v /usr/share/man/man3/{Thread,Tcl_Thread}.3
cd ..
tar -xf ../tcl8.6.17-html.tar.gz --strip-components=1
mkdir -v -p /usr/share/doc/tcl-8.6.17
cp -v -r  ./html/* /usr/share/doc/tcl-8.6.17

echo "Expect-5.45.4"
sleep 3
echo "Extrayendo expect5.45.4.tar.gz"
tar -xf expect5.45.4.tar.gz
cd expect5.45.4
python3 -c 'from pty import spawn; spawn(["echo", "ok"])'
patch -Np1 -i ../expect-5.45.4-gcc15-1.patch
./configure --prefix=/usr           \
            --with-tcl=/usr/lib     \
            --enable-shared         \
            --disable-rpath         \
            --mandir=/usr/share/man \
            --with-tclinclude=/usr/include
make
make test
make install
ln -svf expect5.45.4/libexpect5.45.4.so /usr/lib
cd /sources
rm -rf expect5.45.4

echo "DejaGNU-1.6.3"
sleep 3
echo "Extrayendo dejagnu-1.6.3.tar.gz"
tar -xf dejagnu-1.6.3.tar.gz
cd dejagnu-1.6.3
mkdir -v build
cd       build
../configure --prefix=/usr
makeinfo --html --no-split -o doc/dejagnu.html ../doc/dejagnu.texi
makeinfo --plaintext       -o doc/dejagnu.txt  ../doc/dejagnu.texi
make check
make install
install -v -dm755  /usr/share/doc/dejagnu-1.6.3
install -v -m644   doc/dejagnu.{html,txt} /usr/share/doc/dejagnu-1.6.3
cd /sources
rm -rf dejagnu-1.6.3

echo "Pkgconf-2.5.1"
sleep 3
echo "Extrayendo pkgconf-2.5.1.tar.xz"
tar -xf pkgconf-2.5.1.tar.xz
cd pkgconf-2.5.1
./configure --prefix=/usr    \
            --disable-static \
            --docdir=/usr/share/doc/pkgconf-2.5.1
make
make install
ln -sv pkgconf   /usr/bin/pkg-config
ln -sv pkgconf.1 /usr/share/man/man1/pkg-config.1
cd /sources
rm -rf pkgconf-2.5.1

echo "Binutils-2.46.0"
sleep 3
echo "Extrayendo binutils-2.46.0.tar.xz"
tar -xf binutils-2.46.0.tar.xz
cd binutils-2.46.0
mkdir -v build
cd       build
../configure --prefix=/usr       \
             --sysconfdir=/etc   \
             --enable-ld=default \
             --enable-plugins    \
             --enable-shared     \
             --disable-werror    \
             --enable-64-bit-bfd \
             --enable-new-dtags  \
             --with-system-zlib  \
             --enable-default-hash-style=gnu
make tooldir=/usr
make -k check
grep '^FAIL:' $(find -name '*.log')
make tooldir=/usr install
rm -rfv /usr/lib/lib{bfd,ctf,ctf-nobfd,gprofng,opcodes,sframe}.a \
        /usr/share/doc/gprofng/
cd /sources
rm -rf binutils-2.46.0

echo "GMP-6.3.0"
sleep 3
echo "Extrayendo gmp-6.3.0.tar.xz"
tar -xf gmp-6.3.0.tar.xz
cd gmp-6.3.0
sed -i '/long long t1;/,+1s/()/(...)/' configure
./configure --prefix=/usr    \
            --enable-cxx     \
            --disable-static \
            --docdir=/usr/share/doc/gmp-6.3.0
make
make html
make check 2>&1 | tee gmp-check-log
awk '/# PASS:/{total+=$3} ; END{print total}' gmp-check-log
make install
make install-html
cd /sources
rm -rf gmp-6.3.0

echo "MPFR-4.2.2"
sleep 3
echo "Extrayendo mpfr-4.2.2.tar.xz"
tar -xf mpfr-4.2.2.tar.xz
cd mpfr-4.2.2
./configure --prefix=/usr        \
            --disable-static     \
            --enable-thread-safe \
            --docdir=/usr/share/doc/mpfr-4.2.2
make
make html
make check
make install
make install-html
cd /sources
rm -rf mpfr-4.2.2

echo "MPC-1.3.1"
sleep 3
echo "Extrayendo mpc-1.3.1.tar.gz"
tar -xf mpc-1.3.1.tar.gz
cd mpc-1.3.1
./configure --prefix=/usr    \
            --disable-static \
            --docdir=/usr/share/doc/mpc-1.3.1
make
make html
make check
make install
make install-html
cd /sources
rm -rf mpc-1.3.1

echo "Attr-2.5.2"
sleep 3
echo "Extrayendo attr-2.5.2.tar.gz"
tar -xf attr-2.5.2.tar.gz
cd attr-2.5.2
./configure --prefix=/usr     \
            --disable-static  \
            --sysconfdir=/etc \
            --docdir=/usr/share/doc/attr-2.5.2
make
make check
make install
cd /sources
rm -rf attr-2.5.2

echo "Acl-2.3.2"
sleep 3
echo "Extrayendo acl-2.3.2.tar.gz"
tar -xf acl-2.3.2.tar.gz
cd acl-2.3.2
./configure --prefix=/usr    \
            --disable-static \
            --docdir=/usr/share/doc/acl-2.3.2
make
make check
make install
cd /sources
rm -rf acl-2.3.2

echo "Libcap-2.77"
sleep 3
echo "Extrayendo libcap-2.77.tar.xz"
tar -xf libcap-2.77.tar.xz
cd libcap-2.77
sed -i '/install -m.*STA/d' libcap/Makefile
make prefix=/usr lib=lib
make test
make prefix=/usr lib=lib install
cd /sources
rm -rf libcap-2.77

echo "Libxcrypt-4.5.2"
sleep 3
echo "Extrayendo libxcrypt-4.5.2.tar.xz"
tar -xf libxcrypt-4.5.2.tar.xz
cd libxcrypt-4.5.2
sed -i '/strchr/s/const//' lib/crypt-{sm3,gost}-yescrypt.c
./configure --prefix=/usr                \
            --enable-hashes=strong,glibc \
            --enable-obsolete-api=no     \
            --disable-static             \
            --disable-failure-tokens
make
make check
make install
#make distclean
#./configure --prefix=/usr                \
#            --enable-hashes=strong,glibc \
#            --enable-obsolete-api=glibc  \
#            --disable-static             \
#            --disable-failure-tokens
#make
#cp -av --remove-destination .libs/libcrypt.so.1* /usr/lib
cd /sources
rm -rf libxcrypt-4.5.2

echo "Shadow-4.19.3"
sleep 3
echo "Extrayendo shadow-4.19.3.tar.xz"
tar -xf shadow-4.19.3.tar.xz
cd shadow-4.19.3
sed -i 's/groups$(EXEEXT) //' src/Makefile.in
find man -name Makefile.in -exec sed -i 's/groups\.1 / /'   {} \;
find man -name Makefile.in -exec sed -i 's/getspnam\.3 / /' {} \;
find man -name Makefile.in -exec sed -i 's/passwd\.5 / /'   {} \;
sed -e 's:#ENCRYPT_METHOD DES:ENCRYPT_METHOD YESCRYPT:' \
    -e 's:/var/spool/mail:/var/mail:'                   \
    -e '/PATH=/{s@/sbin:@@;s@/bin:@@}'                  \
    -i etc/login.defs
touch /usr/bin/passwd
./configure --sysconfdir=/etc   \
            --disable-static    \
            --with-{b,yes}crypt \
            --without-libbsd    \
            --disable-logind    \
            --with-group-name-max-length=32
make
make exec_prefix=/usr install
make -C man install-man

echo "Configuring Shadow"
pwconv
grpconv
mkdir -p /etc/default
useradd -D --gid 999
sed -i '/MAIL/s/yes/no/' /etc/default/useradd
passwd root
cd /sources
rm -rf shadow-4.19.3

echo "GCC-15.2.0"
sleep 3
echo "Extrayendo gcc-15.2.0.tar.xz"
tar -xf gcc-15.2.0.tar.xz
cd gcc-15.2.0
sed -i 's/char [*]q/const &/' libgomp/affinity-fmt.c
case $(uname -m) in
  x86_64)
    sed -e '/m64=/s/lib64/lib/' \
        -i.orig gcc/config/i386/t-linux64
  ;;
esac
mkdir -v build
cd       build
../configure --prefix=/usr            \
             LD=ld                    \
             --enable-languages=c,c++ \
             --enable-default-pie     \
             --enable-default-ssp     \
             --enable-host-pie        \
             --disable-multilib       \
             --disable-bootstrap      \
             --disable-fixincludes    \
             --with-system-zlib
make
ulimit -s -H unlimited
sed -e '/cpython/d' -i ../gcc/testsuite/gcc.dg/plugin/plugin.exp
chown -R tester .
su tester -c "PATH=$PATH make -k check"
../contrib/test_summary
make install
chown -v -R root:root \
    /usr/lib/gcc/$(gcc -dumpmachine)/15.2.0/include{,-fixed}
ln -svr /usr/bin/cpp /usr/lib
ln -sv gcc.1 /usr/share/man/man1/cc.1
ln -sfv ../../libexec/gcc/$(gcc -dumpmachine)/15.2.0/liblto_plugin.so \
        /usr/lib/bfd-plugins/
echo 'int main(){}' | cc -x c - -v -Wl,--verbose &> dummy.log
readelf -l a.out | grep ': /lib'
sleep 3
grep -E -o '/usr/lib.*/S?crt[1in].*succeeded' dummy.log
sleep 3
grep -B4 '^ /usr/include' dummy.log
sleep 3
grep 'SEARCH.*/usr/lib' dummy.log |sed 's|; |\n|g'
sleep 3
grep "/lib.*/libc.so.6 " dummy.log
sleep 3
grep found dummy.log
sleep 3
rm -v a.out dummy.log
mkdir -pv /usr/share/gdb/auto-load/usr/lib
mv -v /usr/lib/*gdb.py /usr/share/gdb/auto-load/usr/lib
cd /sources
rm -rf gcc-15.2.0