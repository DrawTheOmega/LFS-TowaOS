#!/bin/bash

# ROOT

cat >> /etc/fstab << EOF
/dev/sda8   ${LFS}/           ext4    defaults    1 1
/dev/sda3   ${LFS}/boot       ext4    defaults    1 1
/dev/sda4   ${LFS}/boot/efi   vfat    umask=0077  1 1
/dev/sda5   ${LFS}/opt        ext4    defaults    1 1
/dev/sda6   ${LFS}/usr/src    ext4    defaults    1 1
EOF
