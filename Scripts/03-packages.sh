#!/bin/bash

mkdir -v $LFS/sources
chmod -v a+wt $LFS/sources
cd $LFS/sources

wget https://www.linuxfromscratch.org/lfs/view/stable-systemd/wget-list-systemd
wget --input-file=wget-list-systemd --continue --directory-prefix=$LFS/sources

wget https://www.linuxfromscratch.org/lfs/view/stable-systemd/md5sums
pushd $LFS/sources
    md5sum -c md5sums
popd