#!/bin/bash

#ROOT
#Post chroot, pre 08

mountpoint -q $LFS/dev/shm && umount $LFS/dev/shm
umount $LFS/dev/pts
umount $LFS/{sys,proc,run,dev}
cd $LFS
tar -cJpf $HOME/lfs-temp-tools-13.0-systemd.tar.xz .

echo "Luego del backup y para seguir en chroot ejecutar el script 07-01-first-chroot.sh ya que no va a haber ninguna unidad montada"