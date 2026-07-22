# Capitulo 6

A continuación se deja como debería de compilarse cada paquete.

## M4-1.4.21
./configure --prefix=/usr --host=$LFS_TGT --build=$(build-aux/config.guess)
make
make DESTDIR=$LFS install

## Ncurses-6.6
mkdir build
@pushd build
../configure --prefix=$LFS/tools AWK=gawk
make -C include
make -C progs tic
install progs/tic $LFS/tools/bin
@popd
./configure --prefix=/usr --host=$LFS_TGT --build=$(./config.guess) --mandir=/usr/share/man --with-manpage-format=normal --with-shared --without-normal --with-cxx-shared --without-debug --without-ada --disable-stripping AWK=gawk
make
make DESTDIR=$LFS install
ln -sv libncursesw.so $LFS/usr/lib/libncurses.so
sed -e 's/^#if.*XOPEN.*$/#if 1/' -i $LFS/usr/include/curses.h

## Bash-5.3
./configure --prefix=/usr --build=$(sh support/config.guess) --host=$LFS_TGT --without-bash-malloc
make
make DESTDIR=$LFS install
ln -sv bash $LFS/bin/sh

# Coreutils-9.10
./configure --prefix=/usr --host=$LFS_TGT --build=$(build-aux/config.guess) --enable-install-program=hostname --enable-no-install-program=kill,uptime
make
make DESTDIR=$LFS install
mv -v $LFS/usr/bin/chroot $LFS/usr/sbin
mkdir -pv $LFS/usr/share/man/man8
mv -v $LFS/usr/share/man/man1/chroot.1 $LFS/usr/share/man/man8/chroot.8
sed -i 's/"1"/"8"/' $LFS/usr/share/man/man8/chroot.8

## Diffutils-3.12
./configure --prefix=/usr --host=$LFS_TGT gl_cv_func_strcasecmp_works=y --build=$(./build-aux/config.guess)
make
make DESTDIR=$LFS install

## File-5.46
mkdir build
@pushd build
../configure --disable-bzlib --disable-libseccomp --disable-gzlib --disable-zlib
make
@popd
./configure --prefix=/usr --host=$LFS_TGT --build=$(./config.guess)
make FILE_COMPILE=$(pwd)/build/src/file
make DESTDIR=$LFS install
rm -v $LFS/usr/lib/libmagic.la

## Findutils-4.10.0
./configure --prefix=/usr --localstatedir=/var/lib/locate --host=$LFS_TGT --build=$(build-aux/config.guess)
make
make DESTDIR=$LFS install

## Gawk-5.3.2
sed -i 's/extras//' Makefile.in
./configure --prefix=/usr --host=$LFS_TGT --build=$(build-aux/config.guess)
make
make DESTDIR=$LFS install

## Grep-3.12
./configure --prefix=/usr  --host=$LFS_TGT --build=$(build-aux/config.guess)
make
make DESTDIR=$LFS install

## Gzip-1.14
./configure --prefix=/usr --host=$LFS_TGT
make
make DESTDIR=$LFS install

## Make-4.4.1
./configure --prefix=/usr --host=$LFS_TGT --build=$(build-aux/config.guess)
make
make DESTDIR=$LFS install

## Patch-2.8
./configure --prefix=/usr --host=$LFS_TGT --build=$(build-aux/config.guess)
make
make DESTDIR=$LFS install

## Sed-4.9
./configure --prefix=/usr --host=$LFS_TGT --build=$(build-aux/config.guess)
make
make DESTDIR=$LFS install

## Tar-1.35
./configure --prefix=/usr --host=$LFS_TGT --build=$(build-aux/config.guess)
make
make DESTDIR=$LFS install

## xz-5.8.2
./configure --prefix=/usr --host=$LFS_TGT --build=$(build-aux/config.guess) --disable-static --docdir=/usr/share/doc/xz-5.8.2
make
make DESTDIR=$LFS install
rm -v $LFS/usr/lib/liblzma.la

## Binutils-2.46.0 - Pass 2
sed '6031s/$add_dir//' -i ltmain.sh
mkdir -v build
cd build
../configure --prefix=/usr --build=$(../config.guess) --host=$LFS_TGT --disable-nls --enable-shared --enable-gprofng=no  --disable-werror --enable-64-bit-bfd  --enable-new-dtags --enable-default-hash-style=gnu
make
make DESTDIR=$LFS install
rm -v $LFS/usr/lib/lib{bfd,ctf,ctf-nobfd,opcodes,sframe}.{a,la}

## GCC-15.2.0 - Pass 2
    tar -xf ../mpfr-4.2.2.tar.xz
    mv -v mpfr-4.2.2 mpfr
    tar -xf ../gmp-6.3.0.tar.xz
    mv -v gmp-6.3.0 gmp
    tar -xf ../mpc-1.3.1.tar.xz
    mv -v mpc-1.3.1 mpc
    case $(uname -m) in
        x86_64)
            sed -e '/m64=/s/lib64/lib/' -i.orig gcc/config/i386/t-linux64
        ;;
    esac
    sed '/thread_header =/s/@.*@/gthr-posix.h/' -i libgcc/Makefile.in libstdc++-v3/include/Makefile.in
    mkdir -v build
    cd build
    ../configure --build=$(../config.guess) --host=$LFS_TGT --target=$LFS_TGT --prefix=/usr --with-build-sysroot=$LFS --enable-default-pie --enable-default-ssp --disable-nls --disable-multilib --disable-libatomic --disable-libgomp --disable-libquadmath --disable-libsanitizer --disable-libssp --disable-libvtv --enable-languages=c,c++ LDFLAGS_FOR_TARGET=-L$PWD/$LFS_TGT/libgcc
    make
    make DESTDIR=$LFS install
    ln -sv gcc $LFS/usr/bin/cc