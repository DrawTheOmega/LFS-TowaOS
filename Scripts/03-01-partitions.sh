#!/bin/bash

# ROOT

mkdir -pv $LFS
mkfs -v -t ext4 /dev/sda8
mount -v -t ext4 /dev/sda8 $LFS

mkdir -pv $LFS/opt
mkfs -v -t ext4 /dev/sda5
mount -v -t ext4 /dev/sda5 $LFS/opt

mkdir -pv $LFS/usr/src
mkfs -v -t ext4 /dev/sda6
mount -v -t ext4 /dev/sda6 $LFS/usr/src

mkdir -pv $LFS/boot
mkfs -v -t ext4 /dev/sda3
mount -v -t ext4 /dev/sda3 $LFS/boot

mkdir -pv $LFS/boot/efi
mkfs.fat -F 32 /dev/sda4
mount -v -t vfat /dev/sda4 $LFS/boot/efi

chown root:root $LFS
chmod 755 $LFS

mkswap /dev/sda7
swapon -v /dev/sda7

cat >> /etc/fstab << EOF
/dev/sda8   ${LFS}/           ext4    defaults    1 1
/dev/sda3   ${LFS}/boot       ext4    defaults    1 1
/dev/sda4   ${LFS}/boot/efi   vfat    umask=0077  1 1
/dev/sda5   ${LFS}/opt        ext4    defaults    1 1
/dev/sda6   ${LFS}/usr/src    ext4    defaults    1 1
EOF