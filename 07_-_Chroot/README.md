# Capítulo 7

## Introducción

Para este punto vamos a armar un ambiente separado del sistema operativo del host, un entorno "chroot". A continuación se preparará el ambiente para armar el entorno de chroot sin problemas.

## Owner

Como todos los paquetes se compilaron con el usuario de lfs hay que asignar al nuevo owner root, para ello dejamos de usar el usuario de lfs y como root ejecutamos:
    chown --from lfs -R root:root $LFS/{usr,var,etc,tools}
    case $(uname -m) in
    x86_64) chown --from lfs -R root:root $LFS/lib64 ;;
    esac

## Virtual Kernel File Systems

Para un correcto funcionamiento de las siguientes compilaciones y del entorno de chroot se crearan directorios virtuales, estos no ocupan espacio en disco sino que residen en la memoria.
    mkdir -pv $LFS/{dev,proc,sys,run}

### Montando y armando /dev

Durante el booteo del sistema, el kernel monta automáticamente el filesystem de devtmpfs en /dev. Se crean nodos en ese filesystem de archivos virtuales durante el booteo o cuando un dispositivo es detectado por primera vez. Esos nodos son los que vamos a usar para simular un sistema completo, pero no los vamos a copiar a $LFS/dev sino que vamos a enlazarlos directamente:
    mount -v --bind /dev $LFS/dev

### Montando VKFS

Ahora si vamos a montar los diferentes directorios como tmpfs, sysfs, proc y devpts (en algunos casos la unidad de /dev/shm es un link simbólico de /run/shm y para replicarlo hay que darle los permisos correctos):
    mount -vt devpts devpts -o gid=5,mode=0620 $LFS/dev/pts
    mount -vt proc proc $LFS/proc
    mount -vt sysfs sysfs $LFS/sys
    mount -vt tmpfs tmpfs $LFS/run
    if [ -h $LFS/dev/shm ]; then
        install -v -d -m 1777 $LFS$(realpath /dev/shm)
    else
        mount -vt tmpfs -o nosuid,nodev tmpfs $LFS/dev/shm
    fi

## Entrando en Chroot

Ahora que está todo listo, solo queda entrar en chroot. Como usuario root ejecutamos el siguiente comando:
    chroot "$LFS" /usr/bin/env -i   \
        HOME=/root                  \
        TERM="$TERM"                \
        PS1='(lfs chroot) \u:\w\$ ' \
        PATH=/usr/bin:/usr/sbin     \
        MAKEFLAGS="-j$(nproc)"      \
        TESTSUITEFLAGS="-j$(nproc)" \
        /bin/bash --login

Va a aparecer que el usuario es "I have no name!" ya que todavía no existe ningun usuario creado en /etc/passwd, más adelante se soluciona.

## Directorios

Los siguientes directorios son los que vamos a usar (no son todos pero son los únicos que usamon para este proceso):

    mkdir -pv /{boot,home,mnt,opt,srv}
    mkdir -pv /etc/{opt,sysconfig}
    mkdir -pv /lib/firmware
    mkdir -pv /media/{floppy,cdrom}
    mkdir -pv /usr/{,local/}{include,src}
    mkdir -pv /usr/lib/locale
    mkdir -pv /usr/local/{bin,lib,sbin}
    mkdir -pv /usr/{,local/}share/{color,dict,doc,info,locale,man}
    mkdir -pv /usr/{,local/}share/{misc,terminfo,zoneinfo}
    mkdir -pv /usr/{,local/}share/man/man{1..8}
    mkdir -pv /var/{cache,local,log,mail,opt,spool}
    mkdir -pv /var/lib/{color,misc,locate}

    ln -sfv /run /var/run
    ln -sfv /run/lock /var/lock

    install -dv -m 0750 /root
    install -dv -m 1777 /tmp /var/tmp

## Archivos y Symlinks esenciales

Listado de directorios montados
    ln -sv /proc/self/mounts /etc/mtab

Archivo hosts
    cat > /etc/hosts << EOF
    127.0.0.1  localhost $(hostname)
    ::1        localhost
    EOF

Archivo passwd
    cat > /etc/passwd << "EOF"
    root:x:0:0:root:/root:/bin/bash
    bin:x:1:1:bin:/dev/null:/usr/bin/false
    daemon:x:6:6:Daemon User:/dev/null:/usr/bin/false
    messagebus:x:18:18:D-Bus Message Daemon User:/run/dbus:/usr/bin/false
    systemd-journal-gateway:x:73:73:systemd Journal Gateway:/:/usr/bin/false
    systemd-journal-remote:x:74:74:systemd Journal Remote:/:/usr/bin/false
    systemd-journal-upload:x:75:75:systemd Journal Upload:/:/usr/bin/false
    systemd-network:x:76:76:systemd Network Management:/:/usr/bin/false
    systemd-resolve:x:77:77:systemd Resolver:/:/usr/bin/false
    systemd-timesync:x:78:78:systemd Time Synchronization:/:/usr/bin/false
    systemd-coredump:x:79:79:systemd Core Dumper:/:/usr/bin/false
    uuidd:x:80:80:UUID Generation Daemon User:/dev/null:/usr/bin/false
    systemd-oom:x:81:81:systemd Out Of Memory Daemon:/:/usr/bin/false
    nobody:x:65534:65534:Unprivileged User:/dev/null:/usr/bin/false
    EOF

Grupos
    cat > /etc/group << "EOF"
    root:x:0:
    bin:x:1:daemon
    sys:x:2:
    kmem:x:3:
    tape:x:4:
    tty:x:5:
    daemon:x:6:
    floppy:x:7:
    disk:x:8:
    lp:x:9:
    dialout:x:10:
    audio:x:11:
    video:x:12:
    utmp:x:13:
    clock:x:14:
    cdrom:x:15:
    adm:x:16:
    messagebus:x:18:
    systemd-journal:x:23:
    input:x:24:
    mail:x:34:
    kvm:x:61:
    systemd-journal-gateway:x:73:
    systemd-journal-remote:x:74:
    systemd-journal-upload:x:75:
    systemd-network:x:76:
    systemd-resolve:x:77:
    systemd-timesync:x:78:
    systemd-coredump:x:79:
    uuidd:x:80:
    systemd-oom:x:81:
    wheel:x:97:
    users:x:999:
    nogroup:x:65534:
    EOF

Usuario de tester para el capítulo 8:
    echo "tester:x:101:101::/home/tester:/bin/bash" >> /etc/passwd
    echo "tester:x:101:" >> /etc/group
    install -o tester -d /home/tester

Como ya están creados los usuarios ahora podemos loggearnos correctamente:
    exec /usr/bin/bash --login

Creamos algunos logs ya que si no existe el archivo algunos servicios no auditan:
    touch /var/log/{btmp,lastlog,faillog,wtmp}
    chgrp -v utmp /var/log/lastlog
    chmod -v 664  /var/log/lastlog
    chmod -v 600  /var/log/btmp

## Herramientas

Ahora vamos a instalar algunas herramientas necesarias:
    Gettext-1.0
    Bison-3.8.2
    Perl-5.42.0
    Python-3.14.3
    Texinfo-7.2
    Util-linux-2.41.3

Para esto usamos el mismo procedimiento de los capítulos 5 y 6, solo cambia el directorio donde están los paquetes. De $LFS/sources pasa a ser /sources dentro de chroot.

### Gettext-1.0

tar -xvf gettext-1.0.tar.gz
cd gettext-1.0
./configure --disable-shared
make
cp -v gettext-tools/src/{msgfmt,msgmerge,xgettext} /usr/bin
cd /sources
rm -rf gettext-1.0

### Bison-3.8.2

tar -xvf bison-3.8.2.tar.gz
cd bison-3.8.2
./configure --prefix=/usr \
            --docdir=/usr/share/doc/bison-3.8.2
make
make install
cd /sources
rm -rf bison-3.8.2

### Perl-5.42.0

tar -xvf perl-5.42.0.tar.xz
cd perl-5.42.0
sh Configure -des                                         \
             -D prefix=/usr                               \
             -D vendorprefix=/usr                         \
             -D useshrplib                                \
             -D privlib=/usr/lib/perl5/5.42/core_perl     \
             -D archlib=/usr/lib/perl5/5.42/core_perl     \
             -D sitelib=/usr/lib/perl5/5.42/site_perl     \
             -D sitearch=/usr/lib/perl5/5.42/site_perl    \
             -D vendorlib=/usr/lib/perl5/5.42/vendor_perl \
             -D vendorarch=/usr/lib/perl5/5.42/vendor_perl
make
make install
cd /sources
rm -rf perl-5.42.0

### Python-3.14.3

tar -xvf Python-3.14.3.tar.xz
cd Python-3.14.3
./configure --prefix=/usr       \
            --enable-shared     \
            --without-ensurepip \
            --without-static-libpython
make
make install

### Texinfo-7.2

tar -xvf texinfo-7.2.tar.xz
cd texinfo-7.2
./configure --prefix=/usr
make
make install
cd /sources
rm -rf texinfo-7.2

### Util-linux-2.41.3

tar -xvf util-linux-2.41.3.tar.xz
cd util-linux-2.41.3
mkdir -pv /var/lib/hwclock
./configure --libdir=/usr/lib     \
            --runstatedir=/run    \
            --disable-chfn-chsh   \
            --disable-login       \
            --disable-nologin     \
            --disable-su          \
            --disable-setpriv     \
            --disable-runuser     \
            --disable-pylibmount  \
            --disable-static      \
            --disable-liblastlog2 \
            --without-python      \
            ADJTIME_PATH=/var/lib/hwclock/adjtime \
            --docdir=/usr/share/doc/util-linux-2.41.3
make
make install
cd /sources
rm -rf util-linux-2.41.3

## Limpieza

Una vez instaladas las herramientas vamos a borrar algunos docs y archivos temporales que dejaron:
    rm -rf /usr/share/{info,man,doc}/*
    find /usr/{lib,libexec} -name \*.la -delete
    rm -rf /tools

Así liberamos unos 1.1GB de espacio.

## Backup

Es una buena idea tener una copia de seguridad para este punto por si cometemos un error más adelante con la compilación, también podemos tomarnos una pausa en el medio del siguiente capítulo para hacer una copia en ese punto.
Antes que nada nos aseguramos de salir del entorno de chroot:
    exit

Revisar que tengamos las variables de entorno bien configuradas como root. Antes de hacer un backup debemos desmontar las VKFS:
    mountpoint -q $LFS/dev/shm && umount $LFS/dev/shm
    umount $LFS/dev/pts
    umount $LFS/{sys,proc,run,dev}
    cd $LFS
    tar -cJpf $HOME/lfs-temp-tools-13.0-systemd.tar.xz .

## Restore

En caso de cometer algún error durante la compilación siempre podemos volver atrás con un backup para no volver a empezar de 0:
    cd $LFS
    rm -rf ./*
    tar -xpf $HOME/lfs-temp-tools-13.0-systemd.tar.xz

## Volver a chroot

Una vez hecho el backup o restore, para volver lo único que hay que hacer es verificar si están montadas las VKFS (findmnt | grep $LFS). Si no está montado repetimos los pasos de "Virtual Kernel File Systems" y entramos en chroot.