#!/bin/bash

#CHROOT
#8.52
cd /sources

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
echo "Extrayendo XML-Parser-2.47.tar.gz
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