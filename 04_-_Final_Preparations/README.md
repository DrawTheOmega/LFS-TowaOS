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

