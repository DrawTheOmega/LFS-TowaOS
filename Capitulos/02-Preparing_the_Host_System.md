# Capítulo 2

## Hardware

Se recomienda usar una CPU con al menos 4 cores y tener 8GB de RAM, no es tanto por un impedimento lógico sino que a la hora de compilar algunos paquetes tarda demasiado.

## Software

Esta es una lista del software que se necesitará para el proceso, con sus versiones mínimas recomendadas:

- Bash-3.2 (/bin/sh posiblemente sea un link de bash)
- Binutils-2.13.1 (Versiones mayores a 2.46.0 no son - recomendadas porque no fueron probadas)
- Bison-2.7 (/usr/bin/yacc a lo mejor es un link a bison o a un script que ejecuta bison)
- Coreutils-8.1
- Diffutils-2.8.1
- Findutils-4.2.31
- Gawk-4.0.1 (/usr/bin/awk a lo mejor es un link a gawk)
- GCC-5.4 incluye un compilador de C++, g++ (versiones mayores a 15.2.0 no son recomendadas ya que no fueron probadas). Las librerias bases de C y C++ (con headers) suelen estar presentes así que el compilador de C++ podría compilar los programas
- Grep-2.5.1a
- Gzip-1.3.12
- Linux Kernel-5.4
- M4-1.4.10
- Make-4.0
- Patch-2.5.4
- Perl-5.8.8
- Python-3.4
- Sed-4.1.5
- Tar-1.22
- Texinfo-5.0
- Xz-5.0.0

Con el script de "01-version-check.sh" se puede revisar las versiones de los programas requeridos para el proceso.

## Particiones

Es recomendable trabajar con una partición de 30GB. No necesita tanto de base pero se generan varios archivos temporales en las compilaciones. También puede venir bien tener un poco de espacio extra para el swap.
Para esta parte se usará fdisk o cfdisk así que conviene investigar un poco.

### Problemas en las particiones

Las solicitudes de asesoramiento sobre la partición del sistema suelen publicarse en el Listas de correo de LFS. Este es un tema muy subjetivo. El predeterminado para la mayoría de las distribuciones es usar toda la unidad con la Excepto una pequeña partición de swap. Esto no es lo óptimo para el LFS Por varias razones. Reduce la flexibilidad y facilita el intercambio de datos entre múltiples distribuciones o construcciones LFS más difíciles, hace que las copias de seguridad consumen más tiempo y pueden desperdiciar espacio en disco asignación ineficiente de estructuras del sistema de archivos.

#### Partición raiz

Con unos 20GB para el raiz debería estar bien, si se busca hacer el proyecto de BLFS luego es posible que requiera más. Es recomendable experimentar con varias particiones para aprender.

#### SWAP

Por norma general se usa el doble de la memoria RAM, especialmente cuando se hiberna el equipo ya que manda todo lo cargado en la RAM hacia el disco, si ya está declarado el SWAP no va a tener inconvenientes para volcarlo. Pero aun así el swapping no es recomendable, menos para discos mecánicos que deben acceder físicamente a la información.

#### GRUB

El GRUB no necesita mucho espacio, está bien con 1MB porque solo tiene la tabla de particiones, y tiene la etiqueta de "BIOS Boot".

### Particiones Recomendadas

- /boot - 200MB
- /boot/efi - 100MB (Recomendado para BLFS)
- /home - Muy recomendado si se va a tener múltiples usuarios, suele ocupar bastante espacio
- /usr - En LFS, los directorios de /bin, /lib y /sbin son links a sus contrapartes dentro de /usr. No es necesario crearle una particion pero si se hace hay que darle bastante espacio porque contiene todo los programas y servicios que harán correr el sistema.
- /otp - Es recomendable para BLFS, suele tener librerías y paquetes como KDE o Texlive por lo que usar 5GB o 10GB para esta particion.
- /tmp - Se monta por defecto tmpfs, más adelante se habla en profindidad pero de base no es necesario darle una partición.

## Creación de File System

La forma de crear el File System es con el siguiente comando:
    
    mkfs -v -t ext4 /dev/<xxx>

Donde -v es la flag de verbose para ver en detalle el trabajo que se hace, -t es la flag de type para declarar el tipo de FS que se quiere (ext2, ext3, ext4, fat, etc) y <xxx> siendo la partición a asignar.
Para crear el FS de swap se usa el siguiente comando:
    
    mkswap /dev/<yyy>

Donde <yyy> es la partición destinada al swap.

En "Particiones.md" se deja un ejemplo de como se trabajarán las particiones

## Seteando las variables
Se recomienda el uso de variables de entorno ya que durante todo el proceso se usaran comandos donde las rutas apuntadas están declaradas como por ejemplo "$LFS/tools". Las variables son:

    export LFS=/mnt/lfs
    umask 022
    export MAKEFLAGS=-j$(nproc)

Configurar el umask en 022 garantiza que los archivos recién creados y Los directorios solo pueden ser escritos por su propietario, pero son legibles por cualquiera. Un umask excesivamente permisivo puede dejar huecos de seguridad en el LFS, y un umask demasiado restrictivo puede causar extraños problemas para construir o usar el sistema LFS.
Para una mayor comodidad puede convenir declarar las variables en ~/.bashrc por si se cierra sesión y se sigue más adelante.

## Montando las particiones

La manera de montar las particiones es primero crear el directorio, vamos a aprovechar las variables creadas anteriormente. Primero se crea el directorio con "mkdir" y luego se monta la unidad con "mount":

    mkdir -pv $LFS
    mount -v -t ext4 /dev/<xxx> $LFS

Donde -p en mkdir es crear los directorios necesarios hasta llegar al deseado y <xxx> es la unidad que se monta con mount.

Si se desea tener varias particiones es recomendado el siguiente formato:

    mkdir -pv $LFS
    mount -v -t ext4 /dev/<xxx> $LFS
    mkdir -v $LFS/home
    mount -v -t ext4 /dev/<yyy> $LFS/home

Hay que setear el owner y grupo de root como propietarios, con permisos 755 (rwxr-xr-x)

    chown root:root $LFS
    chmod 755 $LFS

Y por último, para asignar el swap se usa el comando swapon (puede no tener un alias asignado si se ejecuta todo desde una live iso)

    /sbin/swapon -v /dev/<zzz>

Donde <zzz> es la partición destinada al swap

En "02-mount.sh" se deja como se usará en estas pruebas.

En caso de no hacer todo el proceso en un solo día (o dejar el equipo prendido hasta terminar) se recomienda agregar en fstab las particiones para no tener que asignarlas cada vez. En "03-fstab.sh" hay un ejemplo de como sería.