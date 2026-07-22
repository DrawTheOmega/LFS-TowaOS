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
touch /etc/ld.so.conf
sed '/test-installation/s@$(PERL)@echo not running@' -i ../Makefile
make install
sed '/RTLDLIST=/s@/usr@@g' -i /usr/bin/ldd
localedef -i C -f UTF-8 C.UTF-8
localedef -i cs_CZ -f UTF-8 cs_CZ.UTF-8
localedef -i de_DE -f ISO-8859-1 de_DE
localedef -i de_DE@euro -f ISO-8859-15 de_DE@euro
localedef -i de_DE -f UTF-8 de_DE.UTF-8
localedef -i el_GR -f ISO-8859-7 el_GR
localedef -i en_GB -f ISO-8859-1 en_GB
localedef -i en_GB -f UTF-8 en_GB.UTF-8
localedef -i en_HK -f ISO-8859-1 en_HK
localedef -i en_PH -f ISO-8859-1 en_PH
localedef -i en_US -f ISO-8859-1 en_US
localedef -i en_US -f UTF-8 en_US.UTF-8
localedef -i es_ES -f ISO-8859-15 es_ES@euro
localedef -i es_MX -f ISO-8859-1 es_MX
localedef -i fa_IR -f UTF-8 fa_IR
localedef -i fr_FR -f ISO-8859-1 fr_FR
localedef -i fr_FR@euro -f ISO-8859-15 fr_FR@euro
localedef -i fr_FR -f UTF-8 fr_FR.UTF-8
localedef -i is_IS -f ISO-8859-1 is_IS
localedef -i is_IS -f UTF-8 is_IS.UTF-8
localedef -i it_IT -f ISO-8859-1 it_IT
localedef -i it_IT -f ISO-8859-15 it_IT@euro
localedef -i it_IT -f UTF-8 it_IT.UTF-8
localedef -i ja_JP -f EUC-JP ja_JP
localedef -i ja_JP -f UTF-8 ja_JP.UTF-8
localedef -i nl_NL@euro -f ISO-8859-15 nl_NL@euro
localedef -i ru_RU -f KOI8-R ru_RU.KOI8-R
localedef -i ru_RU -f UTF-8 ru_RU.UTF-8
localedef -i se_NO -f UTF-8 se_NO.UTF-8
localedef -i ta_IN -f UTF-8 ta_IN.UTF-8
localedef -i tr_TR -f UTF-8 tr_TR.UTF-8
localedef -i zh_CN -f GB18030 zh_CN.GB18030
localedef -i zh_HK -f BIG5-HKSCS zh_HK.BIG5-HKSCS
localedef -i zh_TW -f UTF-8 zh_TW.UTF-8
make localedata/install-locales
echo "Configuring Glibc"
sleep 3
cat > /etc/nsswitch.conf << "EOF"
# Begin /etc/nsswitch.conf

passwd: files systemd
group: files systemd
shadow: files systemd

hosts: mymachines resolve [!UNAVAIL=return] files myhostname dns
networks: files

protocols: files
services: files
ethers: files
rpc: files

# End /etc/nsswitch.conf
EOF
tar -xf ../../tzdata2025c.tar.gz
ZONEINFO=/usr/share/zoneinfo
mkdir -pv $ZONEINFO/{posix,right}
for tz in etcetera southamerica northamerica europe africa antarctica  \
          asia australasia backward; do
    zic -L /dev/null   -d $ZONEINFO       ${tz}
    zic -L /dev/null   -d $ZONEINFO/posix ${tz}
    zic -L leapseconds -d $ZONEINFO/right ${tz}
done
cp -v zone.tab zone1970.tab iso3166.tab $ZONEINFO
zic -d $ZONEINFO -p America/New_York
unset ZONEINFO tz
tzselect
ln -sfv /usr/share/zoneinfo/America/Argentina/Buenos_Aires /etc/localtime
cat > /etc/ld.so.conf << "EOF"
# Begin /etc/ld.so.conf
/usr/local/lib
/opt/lib

EOF
cat >> /etc/ld.so.conf << "EOF"
# Add an include directory
include /etc/ld.so.conf.d/*.conf

EOF
mkdir -pv /etc/ld.so.conf.d
cd /sources
rm -rf glibc-2.43

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
cd /sources
rm -rf zstd-1.5.7

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

echo "Ncurses-6.6"
sleep 3
echo "Extrayendo ncurses-6.6.tar.gz"
tar -xf ncurses-6.6.tar.gz
cd ncurses-6.6
./configure --prefix=/usr           \
            --mandir=/usr/share/man \
            --with-shared           \
            --without-debug         \
            --without-normal        \
            --with-cxx-shared       \
            --enable-pc-files       \
            --with-pkg-config-libdir=/usr/lib/pkgconfig
make
make DESTDIR=$PWD/dest install
sed -e 's/^#if.*XOPEN.*$/#if 1/' \
    -i dest/usr/include/curses.h
cp --remove-destination -av dest/* /
for lib in ncurses form panel menu ; do
    ln -sfv lib${lib}w.so /usr/lib/lib${lib}.so
    ln -sfv ${lib}w.pc    /usr/lib/pkgconfig/${lib}.pc
done
ln -sfv libncursesw.so /usr/lib/libcurses.so
cp -v -R doc -T /usr/share/doc/ncurses-6.6
cd /sources
rm -rf ncurses-6.6

echo "Sed-4.9"
sleep 3
echo "Extrayendo sed-4.9.tar.xz"
tar -xf sed-4.9.tar.xz
cd sed-4.9
./configure --prefix=/usr
make
make html
chown -R tester .
su tester -c "PATH=$PATH make check"
make install
install -d -m755           /usr/share/doc/sed-4.9
install -m644 doc/sed.html /usr/share/doc/sed-4.9
cd /sources
rm -rf sed-4.9

echo "Psmisc-23.7"
sleep 3
echo "Extrayendo psmisc-23.7.tar.xz"
tar -xf psmisc-23.7.tar.xz
cd psmisc-23.7
./configure --prefix=/usr
make
make check
make install
cd /sources
rm -rf psmisc-23.7

echo "Gettext-1.0"
sleep 3
tar -xf gettext-1.0.tar.xz
cd gettext-1.0
./configure --prefix=/usr    \
            --disable-static \
            --docdir=/usr/share/doc/gettext-1.0
make
make check
make install
chmod -v 0755 /usr/lib/preloadable_libintl.so
cd /sources
rm -rf gettext-1.0

echo "Bison-3.8.2"
sleep 3
tar -xf bison-3.8.2.tar.xz
cd bison-3.8.2
./configure --prefix=/usr --docdir=/usr/share/doc/bison-3.8.2
make
make check
make install
cd /sources
rm -rf bison-3.8.2

echo "Grep-3.12"
sleep 3
echo "Extrayendo grep-3.12.tar.xz"
tar -xf grep-3.12.tar.xz
cd grep-3.12
sed -i "s/echo/#echo/" src/egrep.sh
./configure --prefix=/usr
make
make check
make install
cd /sources
rm -rf grep-3.12

echo "Bash-5.3"
sleep 3
echo "Extrayendo bash-5.3.tar.gz"
tar -xf bash-5.3.tar.gz
cd bash-5.3
./configure --prefix=/usr             \
            --without-bash-malloc     \
            --with-installed-readline \
            --docdir=/usr/share/doc/bash-5.3
make
chown -R tester .
LC_ALL=C.UTF-8 su -s /usr/bin/expect tester << "EOF"
set timeout -1
spawn make tests
expect eof
lassign [wait] _ _ _ value
exit $value
EOF
make install
exec /usr/bin/bash --login
cd /sources
rm -rf bash-5.3

echo "Libtool-2.5.4"
sleep 3
echo "Extrayendo libtool-2.5.4.tar.xz"
tar -xf libtool-2.5.4.tar.xz
cd libtool-2.5.4
./configure --prefix=/usr
make
make check
make install
rm -fv /usr/lib/libltdl.a
cd /sources
rm -rf libtool-2.5.4

echo "GDBM-1.26"
sleep 3
echo "Extrayendo gdbm-1.26.tar.gz"
tar -xf gdbm-1.26.tar.gz
cd gdbm-1.26
./configure --prefix=/usr    \
            --disable-static \
            --enable-libgdbm-compat
make
make check
make install
cd /sources
rm -rf gdbm-1.26

echo "Gperf-3.3"
sleep 3
echo "Extrayendo gperf-3.3.tar.gz"
tar -xf gperf-3.3.tar.gz
cd gperf-3.3
./configure --prefix=/usr --docdir=/usr/share/doc/gperf-3.3
make
make check
make install
cd /sources
rm -rf gperf-3.3

echo "Expat-2.7.4"
sleep 3
echo "Extrayendo expat-2.7.4.tar.xz"
tar -xf expat-2.7.4.tar.xz
cd expat-2.7.4
./configure --prefix=/usr    \
            --disable-static \
            --docdir=/usr/share/doc/expat-2.7.4
make
make check
make install
install -v -m644 doc/*.{html,css} /usr/share/doc/expat-2.7.4
cd /sources
rm -rf expat-2.7.4

echo "Inetutils-2.7"
sleep 3
echo "Extrayendo inetutils-2.7.tar.gz"
tar -xf inetutils-2.7.tar.gz
cd inetutils-2.7
sed -i 's/def HAVE_TERMCAP_TGETENT/ 1/' telnet/telnet.c
./configure --prefix=/usr        \
            --bindir=/usr/bin    \
            --localstatedir=/var \
            --disable-logger     \
            --disable-whois      \
            --disable-rcp        \
            --disable-rexec      \
            --disable-rlogin     \
            --disable-rsh        \
            --disable-servers
make
make check
make install
mv -v /usr/{,s}bin/ifconfig
cd /sources
rm -rf inetutils-2.7

echo "Less-692"
sleep 3
echo "Extrayendo less-692.tar.gz"
tar -xf less-692.tar.gz
cd less-692
./configure --prefix=/usr --sysconfdir=/etc
make
make check
make install
cd /sources
rm -rf less-692

echo "Perl-5.42.0"
sleep 3
tar -xf perl-5.42.0.tar.xz
cd perl-5.42.0
export BUILD_ZLIB=False
export BUILD_BZIP2=0
sh Configure -des                                          \
             -D prefix=/usr                                \
             -D vendorprefix=/usr                          \
             -D privlib=/usr/lib/perl5/5.42/core_perl      \
             -D archlib=/usr/lib/perl5/5.42/core_perl      \
             -D sitelib=/usr/lib/perl5/5.42/site_perl      \
             -D sitearch=/usr/lib/perl5/5.42/site_perl     \
             -D vendorlib=/usr/lib/perl5/5.42/vendor_perl  \
             -D vendorarch=/usr/lib/perl5/5.42/vendor_perl \
             -D man1dir=/usr/share/man/man1                \
             -D man3dir=/usr/share/man/man3                \
             -D pager="/usr/bin/less -isR"                 \
             -D useshrplib                                 \
             -D usethreads
make
TEST_JOBS=$(nproc) make test_harness
make install
unset BUILD_ZLIB BUILD_BZIP2
cd /sources
rm -rf perl-5.42.0

echo "XML::Parser-2.47"
sleep 3
echo "Extrayendo XML-Parser-2.47.tar.gz"
tar -xf XML-Parser-2.47.tar.gz
cd XML-Parser-2.47
perl Makefile.PL
make
make test
make install
cd /sources
rm -rf XML-Parser-2.47

echo "Intltool-0.51.0"
sleep 3
echo "Extrayendo intltool-0.51.0.tar.gz"
tar -xf intltool-0.51.0.tar.gz
cd intltool-0.51.0
sed -i 's:\\\${:\\\$\\{:' intltool-update.in
./configure --prefix=/usr
make
make check
make install
install -v -Dm644 doc/I18N-HOWTO /usr/share/doc/intltool-0.51.0/I18N-HOWTO
cd /sources
rm -rf intltool-0.51.0

echo "Autoconf-2.72"
sleep 3
echo "Extrayendo autoconf-2.72.tar.xz"
tar -xf autoconf-2.72.tar.xz
cd autoconf-2.72
./configure --prefix=/usr
make
make check
make install
cd /sources
rm -rf autoconf-2.72

echo "Automake-1.18.1"
sleep 3
echo "Extrayendo automake-1.18.1.tar.xz"
tar -xf automake-1.18.1.tar.xz
cd automake-1.18.1
./configure --prefix=/usr --docdir=/usr/share/doc/automake-1.18.1
make
make -j$(($(nproc)>4?$(nproc):4)) check
make install
cd /sources
rm -rf automake-1.18.1

echo "OpenSSL-3.6.1"
sleep 3
echo "Extrayendo openssl-3.6.1.tar.gz"
cd openssl-3.6.1
./config --prefix=/usr         \
         --openssldir=/etc/ssl \
         --libdir=lib          \
         shared                \
         zlib-dynamic
make
HARNESS_JOBS=$(nproc) make test
sed -i '/INSTALL_LIBS/s/libcrypto.a libssl.a//' Makefile
make MANSUFFIX=ssl install
mv -v /usr/share/doc/openssl /usr/share/doc/openssl-3.6.1
cp -vfr doc/* /usr/share/doc/openssl-3.6.1
cd /sources
rm -rf openssl-3.6.1

echo "Libelf from Elfutils-0.194"
sleep 3
echo "Extrayendo elfutils-0.194.tar.bz2"
tar -xf elfutils-0.194.tar.bz2
cd elfutils-0.194
./configure --prefix=/usr        \
            --disable-debuginfod \
            --enable-libdebuginfod=dummy
make -C lib
make -C libelf
make -C libelf install
install -vm644 config/libelf.pc /usr/lib/pkgconfig
rm /usr/lib/libelf.a
cd /sources
rm -rf elfutils-0.194

echo "Libffi-3.5.2"
sleep 3
echo "Extrayendo libffi-3.5.2.tar.gz"
tar -xf libffi-3.5.2.tar.gz
cd libffi-3.5.2
./configure --prefix=/usr    \
            --disable-static \
            --with-gcc-arch=native
make
make check
make install
cd /sources
rm -rf libffi-3.5.2

echo "Sqlite-3510200"
sleep 3
echo "Extrayendo sqlite-autoconf-3510200.tar.gz"
tar -xf sqlite-autoconf-3510200.tar.gz
cd sqlite-autoconf-3510200
tar -xf ../sqlite-doc-3510200.tar.xz
./configure --prefix=/usr     \
            --disable-static  \
            --enable-fts{4,5} \
            CPPFLAGS="-D SQLITE_ENABLE_COLUMN_METADATA=1 \
                      -D SQLITE_ENABLE_UNLOCK_NOTIFY=1   \
                      -D SQLITE_ENABLE_DBSTAT_VTAB=1     \
                      -D SQLITE_SECURE_DELETE=1"
make LDFLAGS.rpath=""
make install
install -v -m755 -d /usr/share/doc/sqlite-3.51.2
cp -v -R sqlite-doc-3510200/* /usr/share/doc/sqlite-3.51.2
cd /sources
rm -rf sqlite-autoconf-3510200