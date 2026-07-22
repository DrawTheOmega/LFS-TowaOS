# Capitulo 3

## Introduccion

En este capítulo se van a compilar los paquetes más básicos para un sistema Linux. Es recomendable usar las versiones presentadas ya que son las que se probaron en el proyecto. Es posible que algunos paquetes hayan cambiado el path de descarga, en ese caso se deberá buscar manualmente esos paquetes. En caso de no poder encontrarlo se puede usar el [Repositorio de LFS](https://www.linuxfromscratch.org/lfs/mirrors.html#files) aunque no tienen un reposotiorio en America Latina sigue siendo muy útil.

Para poder trabajar cómodamente se va a crear un directorio donde descargaremos y compilaremos todos los paquetes. Para este proceso es importante hacerlo como root ya que es el que tiene permisos de modificar y crear archivos en el directorio de $LFS (si no se usó otro). Ese mismo directorio hay que darle la característica de "Sticky", lo que permite que los usuarios autorizados pueden crear archivos pero solo el propietario de ese archivo puede eliminarlo.

    mkdir -v $LFS/sources
    chmod -v a+wt $LFS/sources

Descargue el archivo de ["wget-list-systemd"](https://www.linuxfromscratch.org/lfs/view/stable-systemd/wget-list-systemd) para tener el listado de paquetes en un archivo, posteriormente usar el siguiente comando para descargar todo en el directorio de sources:

    wget --input-file=wget-list-systemd --continue --directory-prefix=$LFS/sources

Hacer lo mismo con el archivo de ["md5sums"] (https://www.linuxfromscratch.org/lfs/view/stable-systemd/md5sums) para comparar los hashes de los paquetes descargados con los deseados:

    pushd $LFS/sources
        md5sum -c md5sums
    popd

Si los paquetes se descargaron como un usuario que no sea root asignar los permisos correspondientes a todos los paquetes:

    chown root:root $LFS/sources/*