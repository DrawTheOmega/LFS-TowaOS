#!/bin/bash

# Las particiones ya deben existir y estar formateadas. Este script solo las monta en el sistema de archivos LFS.
# Usar fdisk o cfdisk para crear las particiones y mkfs para formatearlas antes de ejecutar este script.

mkdir -pv $LFS
mount -v -t ext4 /dev/sda6 $LFS

mkdir -pv $LFS/opt
mount -v -t ext4 /dev/sda3 $LFS/opt

mkdir -pv $LFS/usr/src
mount -v -t ext4 /dev/sda4 $LFS/usr/src

mkdir -pv $LFS/boot/efi
mount -v -t ext4 /dev/sda1 $LFS/boot
mount -v -t vfat /dev/sda2 $LFS/boot/efi

chown root:root $LFS
chmod 755 $LFS

swapon -v /dev/sda5