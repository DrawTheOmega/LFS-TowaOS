#!/bin/bash

cat >> /etc/fstab << EOF
/dev/sda6   ${LFS}/           ext4    defaults    1 1
/dev/sda1   ${LFS}/boot       ext4    defaults    1 1
/dev/sda2   ${LFS}/boot/efi   vfat    umask=0077  1 1
/dev/sda3   ${LFS}/opt        ext4    defaults    1 1
/dev/sda4   ${LFS}/usr/src    ext4    defaults    1 1
EOF
