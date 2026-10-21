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

mkdir -v $LFS/sources
chmod -v a+wt $LFS/sources
cd $LFS/sources

wget https://www.linuxfromscratch.org/lfs/view/13.0-systemd/wget-list-systemd
wget --input-file=wget-list-systemd --continue --directory-prefix=$LFS/sources

wget https://www.linuxfromscratch.org/lfs/view/13.0-systemd/md5sums
pushd $LFS/sources
    md5sum -c md5sums
popd

chown root:root $LFS/sources/*

mkdir -pv $LFS/{etc,var} $LFS/usr/{bin,lib,sbin}
mkdir -pv $LFS/tools

for i in bin lib sbin; do
    ln -sv usr/$i $LFS/$i
done

case $(uname -m) in
    x86_64) mkdir -pv $LFS/lib64 ;;
esac

groupadd lfs
useradd -s /bin/bash -g lfs -m -k /dev/null lfs
passwd lfs
chown -v lfs $LFS/{usr{,/*},var,etc,tools}
case $(uname -m) in
    x86_64) chown -v lfs $LFS/lib64 ;;
esac
su - lfs
