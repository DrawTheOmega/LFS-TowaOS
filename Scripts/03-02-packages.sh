#!/bin/bash

# ROOT

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
find ~/. -iname "04-lfs.sh" -exec cp {} /home/lfs \; -exec chown lfs:lfs /home/lfs/04-lfs.sh \;
su - lfs
