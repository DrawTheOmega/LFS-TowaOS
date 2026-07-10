#! /bin/bash

#LFS

#Ejecutar como el usuario lfs, no como root. Este script configura el entorno de compilación para LFS.
if [ $(id -u) = "0" ]; then
    echo "Este script no debe ejecutarse como root. Por favor, ejecute como el usuario lfs."
    exit 1
fi

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