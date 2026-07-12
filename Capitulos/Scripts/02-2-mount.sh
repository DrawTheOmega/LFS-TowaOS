#!/bin/bash

# ROOT

# Las particiones ya deben existir y estar formateadas. Este script solo las monta en el sistema de archivos LFS.
# Usar fdisk o cfdisk para crear las particiones y mkfs para formatearlas antes de ejecutar este script.

mkdir -pv $LFS
mount -v -t ext4 /dev/sda8 $LFS

mkdir -pv $LFS/opt
mount -v -t ext4 /dev/sda5 $LFS/opt

mkdir -pv $LFS/usr/src
mount -v -t ext4 /dev/sda6 $LFS/usr/src

mkdir -pv $LFS/boot
mount -v -t ext4 /dev/sda3 $LFS/boot

mkdir -pv $LFS/boot/efi
mount -v -t vfat /dev/sda4 $LFS/boot/efi

chown root:root $LFS
chmod 755 $LFS

swapon -v /dev/sda7

cat >> /etc/fstab << EOF
/dev/sda8   ${LFS}/           ext4    defaults    1 1
/dev/sda3   ${LFS}/boot       ext4    defaults    1 1
/dev/sda4   ${LFS}/boot/efi   vfat    umask=0077  1 1
/dev/sda5   ${LFS}/opt        ext4    defaults    1 1
/dev/sda6   ${LFS}/usr/src    ext4    defaults    1 1
EOF