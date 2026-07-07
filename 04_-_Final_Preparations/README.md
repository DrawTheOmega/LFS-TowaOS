# Capítulo 4

## Creando directorios necesarios para LFS

Se van a crear los directorios finales que debería tener cualquier sistema Linux, se van a usar en el capítulo 6 para compilar los programas de manera temporal, en el capítulo 8 se terminan de compilar algunos. En el capítulo 5 se va a usar cuando se compile glibc y libstdc++.

    mkdir -pv $LFS/{etc,var} $LFS/usr/{bin,lib,sbin}

    for i in bin lib sbin; do
    ln -sv usr/$i $LFS/$i
    done

    case $(uname -m) in
    x86_64) mkdir -pv $LFS/lib64 ;;
    esac

Se van a crear dentro de $LFS los directorios /etc, /var, /usr/bin, /usr/lib, /usr/sbin y en caso de ser un sistema x86_64 se crea el directorio /lib64.
Luego se crean enlaces simbólicos desde /usr/ hacia el raiz de /bin, /lib y /sbin.

Luego se crea un directorio para la compilación cruzada (capítulo 6 y mejor explicado en la documentación oficial)
mkdir -pv $LFS/tools

## Usuario lfs

En este punto se va a crear el usuario encargado de realizar los primeros pasos de LFS, ya que como root es posible hacer desastres en el sistema base y queremos evitar todos los problemas posibles. Se va a crear eñ usuario lfs y darle los permisos en los directorios correspondientes:

    groupadd lfs
    useradd -s /bin/bash -g lfs -m -k /dev/null lfs
    passwd lfs
    chown -v lfs $LFS/{usr{,/*},var,etc,tools}
    case $(uname -m) in
      x86_64) chown -v lfs $LFS/lib64 ;;
    esac
    su - lfs

## Preparando el ambiente para LFS

Vamos a establecer las variables de entorno para el usuario LFS asi como la configuración del perfil

    cat > ~/.bash_profile << "EOF"
    exec env -i HOME=$HOME TERM=$TERM PS1='\u:\w\$ ' /bin/bash
    EOF

    cat > ~/.bashrc << "EOF"
    set +h
    umask 022
    LFS=/mnt/lfs
    LC_ALL=POSIX
    LFS_TGT=$(uname -m)-lfs-linux-gnu
    PATH=/usr/bin
    if [ ! -L /bin ]; then PATH=/bin:$PATH; fi
    PATH=$LFS/tools/bin:$PATH
    CONFIG_SITE=$LFS/usr/share/config.site
    export LFS LC_ALL LFS_TGT PATH CONFIG_SITE
    export MAKEFLAGS=-j$(nproc)
    EOF

    source ~/.bash_profile

## Standard Build Unit (SBU)

Esta va a ser la media tomada para ver cuanto tiempo tarda un paquete en compilar. No es una medida precisa ya que depende totalmente del sistema del host. Por ejemplo, binutils tiene un tiempo de 4.5 SBU que puede tardar 4 minutos en compilar e instalar la primer parte hasta unos 18 minutos.
Es posible aumentar un poco el rendimiento mediante powerprofilesctl:
    powerprofilesctl set performance

## Testing

En algunos paquetes se recomienda hacer la instancia de testing aunque tarde demasiado ya que chequea el estado del compilado, nunca se sabe cuando algo puede fallar por un descuido anterior y es más fácil solucionarlo apenas sale que arrastrarlo por mucho tiempo