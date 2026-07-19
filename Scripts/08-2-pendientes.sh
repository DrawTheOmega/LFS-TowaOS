#!/bin/bash

#CHROOT
#Revisar 8.75. Vim-9.2.0078 por el lenguaje, por las dudas
cd /sources

echo "Python-3.14.3"
sleep 3
echo "Extrayendo Python-3.14.3.tar.xz"
tar -xf Python-3.14.3.tar.xz
cd Python-3.14.3
./configure --prefix=/usr          \
            --enable-shared        \
            --with-system-expat    \
            --enable-optimizations \
            --without-static-libpython
make
make test TESTOPTS="--timeout 120"
make install
cat > /etc/pip.conf << EOF
[global]
root-user-action = ignore
disable-pip-version-check = true
EOF
install -v -dm755 /usr/share/doc/python-3.14.3/html
tar --strip-components=1  \
    --no-same-owner       \
    --no-same-permissions \
    -C /usr/share/doc/python-3.14.3/html \
    -xvf ../python-3.14.3-docs-html.tar.bz2
cd /sources
rm -rf Python-3.14.3

echo "Flit-Core-3.12.0"
sleep 3
echo "Extrayendo flit_core-3.12.0.tar.gz"
tar -xf flit_core-3.12.0.tar.gz
cd flit_core-3.12.0
pip3 wheel -w dist --no-cache-dir --no-build-isolation --no-deps $PWD
pip3 install --no-index --find-links dist flit_core
cd /sources
rm -rf flit_core-3.12.0

echo "Packaging-26.0"
sleep 3
echo "Extrayendo packaging-26.0.tar.gz"
tar -xf packaging-26.0.tar.gz
cd packaging-26.0
pip3 wheel -w dist --no-cache-dir --no-build-isolation --no-deps $PWD
pip3 install --no-index --find-links dist packaging
cd /sources
rm -rf packaging-26.0

echo "Wheel-0.46.3"
sleep 3
echo "Extrayendo wheel-0.46.3.tar.gz"
tar -xf wheel-0.46.3.tar.gz
cd wheel-0.46.3
pip3 wheel -w dist --no-cache-dir --no-build-isolation --no-deps $PWD
pip3 install --no-index --find-links dist wheel
cd /sources
rm -rf wheel-0.46.3

echo "Wheel-0.46.3"
sleep 3
echo "Extrayendo wheel-0.46.3.tar.gz"
tar -xf wheel-0.46.3.tar.gz
cd wheel-0.46.3
pip3 wheel -w dist --no-cache-dir --no-build-isolation --no-deps $PWD
pip3 install --no-index --find-links dist wheel
cd /sources
rm -rf wheel-0.46.3

echo "Setuptools-82.0.0"
sleep 3
echo "Extrayendo setuptools-82.0.0.tar.gz"
tar -xf setuptools-82.0.0.tar.gz
cd setuptools-82.0.0
pip3 wheel -w dist --no-cache-dir --no-build-isolation --no-deps $PWD
pip3 install --no-index --find-links dist setuptools
cd /sources
rm -rf setuptools-82.0.0

echo "Ninja-1.13.2"
sleep 3
echo "Extrayendo ninja-1.13.2.tar.gz"
tar -xf ninja-1.13.2.tar.gz
cd ninja-1.13.2
export NINJAJOBS=4
sed -i '/int Guess/a \
  int   j = 0;\
  char* jobs = getenv( "NINJAJOBS" );\
  if ( jobs != NULL ) j = atoi( jobs );\
  if ( j > 0 ) return j;\
' src/ninja.cc
python3 configure.py --bootstrap --verbose
install -vm755 ninja /usr/bin/
install -vDm644 misc/bash-completion /usr/share/bash-completion/completions/ninja
install -vDm644 misc/zsh-completion  /usr/share/zsh/site-functions/_ninja
cd /sources
rm -rf ninja-1.13.2

echo "Meson-1.10.1"
sleep 3
echo "Extrayendo meson-1.10.1.tar.gz"
tar -xf meson-1.10.1.tar.gz
cd meson-1.10.1
pip3 wheel -w dist --no-cache-dir --no-build-isolation --no-deps $PWD
pip3 install --no-index --find-links dist meson
install -vDm644 data/shell-completions/bash/meson /usr/share/bash-completion/completions/meson
install -vDm644 data/shell-completions/zsh/_meson /usr/share/zsh/site-functions/_meson
cd /sources
rm -rf meson-1.10.1

echo "Kmod-34.2"
sleep 3
echo "Extrayendo kmod-34.2.tar.xz"
tar -xf kmod-34.2.tar.xz
cd kmod-34.2
mkdir -p build
cd       build
meson setup --prefix=/usr ..    \
            --buildtype=release \
            -D manpages=false
ninja
ninja install
cd /sources
rm -rf kmod-34.2

echo "Coreutils-9.10"
sleep 3
echo "Extrayendo coreutils-9.10.tar.xz"
tar -xf coreutils-9.10.tar.xz
cd coreutils-9.10
patch -Np1 -i ../coreutils-9.10-i18n-1.patch
autoreconf -fv
automake -af
FORCE_UNSAFE_CONFIGURE=1 ./configure \
            --prefix=/usr
make
make NON_ROOT_USERNAME=tester check-root
groupadd -g 102 dummy -U tester
chown -R tester . 
su tester -c "PATH=$PATH make -k RUN_EXPENSIVE_TESTS=yes check" \
   < /dev/null
groupdel dummy
make install
mv -v /usr/bin/chroot /usr/sbin
mv -v /usr/share/man/man1/chroot.1 /usr/share/man/man8/chroot.8
sed -i 's/"1"/"8"/' /usr/share/man/man8/chroot.8
cd /sources
rm -rf coreutils-9.10

echo "Diffutils-3.12"
sleep 3
echo "Extrayendo diffutils-3.12.tar.xz"
tar -xf diffutils-3.12.tar.xz
cd diffutils-3.12
./configure --prefix=/usr
make
make check
make install
cd /sources
rm -rf diffutils-3.12

echo "Gawk-5.3.2"
sleep 3
echo "Extrayendo gawk-5.3.2.tar.xz"
tar -xf gawk-5.3.2.tar.xz
cd gawk-5.3.2
sed -i 's/extras//' Makefile.in
./configure --prefix=/usr
make
chown -R tester .
su tester -c "PATH=$PATH make check"
rm -f /usr/bin/gawk-5.3.2
make install
ln -sv gawk.1 /usr/share/man/man1/awk.1
install -vDm644 doc/{awkforai.txt,*.{eps,pdf,jpg}} -t /usr/share/doc/gawk-5.3.2
cd /sources
rm -rf gawk-5.3.2

echo "Findutils-4.10.0"
sleep 3
echo "Extrayendo findutils-4.10.0.tar.xz"
tar -xf findutils-4.10.0.tar.xz
cd findutils-4.10.0
./configure --prefix=/usr --localstatedir=/var/lib/locate
make
chown -R tester .
su tester -c "PATH=$PATH make check"
make install
cd /sources
rm -rf findutils-4.10.0

echo "Groff-1.23.0"
sleep 3
echo "Extrayendo groff-1.23.0.tar.gz"
cd groff-1.23.0
PAGE=<paper_size> ./configure --prefix=/usr
make
make check
make install
cd /sources
rm -rf groff-1.23.0

echo "GRUB-2.14"
sleep 3
echo "Extrayendo grub-2.14.tar.xz"
tar -xf grub-2.14.tar.xz
cd grub-2.14
unset {C,CPP,CXX,LD}FLAGS
sed 's/--image-base/--nonexist-linker-option/' -i configure
./configure --prefix=/usr     \
            --sysconfdir=/etc \
            --disable-efiemu  \
            --disable-werror
make
make install
cd /sources
rm -rf grub-2.14

echo "Gzip-1.14"
sleep 3
echo "Extrayendo gzip-1.14.tar.xz"
tar -xf gzip-1.14.tar.xz
cd gzip-1.14
./configure --prefix=/usr
make
make check
make install
cd /sources
rm -rf gzip-1.14

echo "IPRoute2-6.18.0"
sleep 3
echo "Extrayendo iproute2-6.18.0.tar.xz"
tar -xf iproute2-6.18.0.tar.xz
cd iproute2-6.18.0
sed -i /ARPD/d Makefile
rm -fv man/man8/arpd.8
make NETNS_RUN_DIR=/run/netns
make SBINDIR=/usr/sbin install
install -vDm644 COPYING README* -t /usr/share/doc/iproute2-6.18.0
cd /sources
rm -rf iproute2-6.18.0

echo "Kbd-2.9.0"
sleep 3
echo "Extrayendo kbd-2.9.0.tar.xz"
tar -xf kbd-2.9.0.tar.xz
cd kbd-2.9.0
patch -Np1 -i ../kbd-2.9.0-backspace-1.patch
sed -i '/RESIZECONS_PROGS=/s/yes/no/' configure
sed -i 's/resizecons.8 //' docs/man/man8/Makefile.in
./configure --prefix=/usr --disable-vlock
make
make check
make install
cp -R -v docs/doc -T /usr/share/doc/kbd-2.9.0
cd /sources
rm -rf kbd-2.9.0

echo "Libpipeline-1.5.8"
sleep 3
tar -xf libpipeline-1.5.8.tar.gz
cd libpipeline-1.5.8
./configure --prefix=/usr
make
make install
cd /sources
rm -rf libpipeline-1.5.8

echo "Make-4.4.1"
sleep 3
tar -xf make-4.4.1.tar.gz
cd make-4.4.1
./configure --prefix=/usr
make
chown -R tester .
su tester -c "PATH=$PATH make check"
make install
cd /sources
rm -rf make-4.4.1

echo "Patch-2.8"
sleep 3
echo "Extrayendo patch-2.8.tar.xz"
cd patch-2.8
./configure --prefix=/usr
make
make check
make install
cd /sources
rm -rf patch-2.8

echo "Tar-1.35"
sleep 3
echo "Extrayendo tar-1.35.tar.xz"
tar -xf tar-1.35.tar.xz
cd tar-1.35
FORCE_UNSAFE_CONFIGURE=1  \
./configure --prefix=/usr
make
make check
make install
make -C doc install-html docdir=/usr/share/doc/tar-1.35
cd /sources
rm -rf tar-1.35

echo "Texinfo-7.2"
sleep 3
echo "Extrayendo texinfo-7.2.tar.xz"
tar -xf texinfo-7.2.tar.xz
cd texinfo-7.2
sed 's/! $output_file eq/$output_file ne/' -i tp/Texinfo/Convert/*.pm
./configure --prefix=/usr
make
make check
make install
make TEXMF=/usr/share/texmf install-tex
pushd /usr/share/info
  rm -v dir
  for f in *
    do install-info $f dir 2>/dev/null
  done
popd
cd /sources
rm -rf texinfo-7.2

echo "Vim-9.2.0078"
sleep 3
echo "Extrayendo vim-9.2.0078.tar.gz"
tar -xf vim-9.2.0078.tar.gz
cd vim-9.2.0078
echo '#define SYS_VIMRC_FILE "/etc/vimrc"' >> src/feature.h
./configure --prefix=/usr
make
chown -R tester .
sed '/test_plugin_glvs/d' -i src/testdir/Make_all.mak
su tester -c "TERM=xterm-256color LANG=en_US.UTF-8 make -j1 test" \
   &> vim-test.log
make install
ln -sv vim /usr/bin/vi
for L in  /usr/share/man/{,*/}man1/vim.1; do
    ln -sv vim.1 $(dirname $L)/vi.1
done
ln -sv ../vim/vim92/doc /usr/share/doc/vim-9.2.0078
cat > /etc/vimrc << "EOF"
" Begin /etc/vimrc

" Ensure defaults are set before customizing settings, not after
source $VIMRUNTIME/defaults.vim
let skip_defaults_vim=1

set nocompatible
set backspace=2
set mouse=
syntax on
if (&term == "xterm") || (&term == "putty")
  set background=dark
endif

" End /etc/vimrc
EOF
vim -c ':options'
set spelllang=en,es
set spell
cd /sources
rm -rf vim-9.2.0078

echo "MarkupSafe-3.0.3"
sleep 3
echo "Extrayendo markupsafe-3.0.3.tar.gz"
tar -xf markupsafe-3.0.3.tar.gz
cd markupsafe-3.0.3
pip3 wheel -w dist --no-cache-dir --no-build-isolation --no-deps $PWD
pip3 install --no-index --find-links dist Markupsafe
cd /sources
rm -rf markupsafe-3.0.3

echo "Jinja2-3.1.6"
sleep 3
echo "Extrayendo jinja2-3.1.6.tar.gz"
tar -xf jinja2-3.1.6
cd jinja2-3.1.6
pip3 wheel -w dist --no-cache-dir --no-build-isolation --no-deps $PWD
pip3 install --no-index --find-links dist Jinja2
cd /sources
rm -rf jinja2-3.1.6

echo "Systemd-259.1"
sleep 3
echo "Extrayendo systemd-259.1.tar.gz"
tar -xf systemd-259.1.tar.gz
cd systemd-259.1
sed -e 's/GROUP="render"/GROUP="video"/' \
    -e 's/GROUP="sgx", //'               \
    -i rules.d/50-udev-default.rules.in
mkdir -p build
cd       build
meson setup ..                \
      --prefix=/usr           \
      --buildtype=release     \
      -D default-dnssec=no    \
      -D firstboot=false      \
      -D install-tests=false  \
      -D ldconfig=false       \
      -D sysusers=false       \
      -D rpmmacrosdir=no      \
      -D homed=disabled       \
      -D man=disabled         \
      -D mode=release         \
      -D pamconfdir=no        \
      -D dev-kvm-mode=0660    \
      -D nobody-group=nogroup \
      -D sysupdate=disabled   \
      -D ukify=disabled       \
      -D docdir=/usr/share/doc/systemd-259.1
ninja
echo 'NAME="LFS TowaOS"' > /etc/os-release
unshare -m ninja test
ninja install
tar -xf ../../systemd-man-pages-259.1.tar.xz \
    --no-same-owner --strip-components=1     \
    -C /usr/share/man
systemd-machine-id-setup
systemctl preset-all
cd /sources
rm -rf systemd-259.1

echo "D-Bus-1.16.2"
sleep 3
echo "Extrayendo dbus-1.16.2.tar.xz"
tar -xf dbus-1.16.2.tar.xz
cd dbus-1.16.2
mkdir build
cd    build
meson setup --prefix=/usr --buildtype=release --wrap-mode=nofallback ..
ninja
ninja test
ninja install
ln -sfv /etc/machine-id /var/lib/dbus
cd /sources
rm -rf dbus-1.16.2

echo "Man-DB-2.13.1"
sleep 3
echo "Extrayendo man-db-2.13.1.tar.xz"
tar -xf man-db-2.13.1.tar.xz
cd man-db-2.13.1
./configure --prefix=/usr                         \
            --docdir=/usr/share/doc/man-db-2.13.1 \
            --sysconfdir=/etc                     \
            --disable-setuid                      \
            --enable-cache-owner=bin              \
            --with-browser=/usr/bin/lynx          \
            --with-vgrind=/usr/bin/vgrind         \
            --with-grap=/usr/bin/grap
make
make check
make install
cd /sources
rm -rf man-db-2.13.1

echo "Procps-ng-4.0.6"
sleep 3
echo "Extrayendo procps-ng-4.0.6.tar.xz"
tar -xf procps-ng-4.0.6.tar.xz
cd procps-ng-4.0.6
./configure --prefix=/usr                           \
            --docdir=/usr/share/doc/procps-ng-4.0.6 \
            --disable-static                        \
            --disable-kill                          \
            --enable-watch8bit                      \
            --with-systemd
make
chown -R tester .
su tester -c "PATH=$PATH make check"
make install
cd /sources
rm -rf procps-ng-4.0.6

echo "Util-linux-2.41.3"
sleep 3
echo "Extrayendo util-linux-2.41.3.tar.xz"
tar -xf util-linux-2.41.3.tar.xz
cd util-linux-2.41.3
./configure --bindir=/usr/bin     \
            --libdir=/usr/lib     \
            --runstatedir=/run    \
            --sbindir=/usr/sbin   \
            --disable-chfn-chsh   \
            --disable-login       \
            --disable-nologin     \
            --disable-su          \
            --disable-setpriv     \
            --disable-runuser     \
            --disable-pylibmount  \
            --disable-liblastlog2 \
            --disable-static      \
            --without-python      \
            ADJTIME_PATH=/var/lib/hwclock/adjtime \
            --docdir=/usr/share/doc/util-linux-2.41.3
make
#bash tests/run.sh --srcdir=$PWD --builddir=$PWD #Para probar el paquete, puede romper el sistema si se ejecuta como root
touch /etc/fstab
chown -R tester .
su tester -c "make -k check"
make install
cd /sources
rm -rf

echo "E2fsprogs-1.47.3"
sleep 3
echo "Extrayendo e2fsprogs-1.47.3.tar.gz"
tar -xf e2fsprogs-1.47.3.tar.gz
cd e2fsprogs-1.47.3
mkdir -v build
cd       build
../configure --prefix=/usr       \
             --sysconfdir=/etc   \
             --enable-elf-shlibs \
             --disable-libblkid  \
             --disable-libuuid   \
             --disable-uuidd     \
             --disable-fsck
make
make check
make install
rm -fv /usr/lib/{libcom_err,libe2p,libext2fs,libss}.a
gunzip -v /usr/share/info/libext2fs.info.gz
install-info --dir-file=/usr/share/info/dir /usr/share/info/libext2fs.info
makeinfo -o      doc/com_err.info ../lib/et/com_err.texinfo
install -v -m644 doc/com_err.info /usr/share/info
install-info --dir-file=/usr/share/info/dir /usr/share/info/com_err.info
sed 's/metadata_csum_seed,//' -i /etc/mke2fs.conf
cd /sources
rm -rf e2fsprogs-1.47.3

echo "Es recomendable hacer un backup ahora, ya que en la limpieza de archivos basura puede romperse algo"