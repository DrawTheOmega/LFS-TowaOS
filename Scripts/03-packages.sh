#!/bin/bash

cat > ~/.bashrc << "EOF"
umask 022
export LFS=/mnt/lfs
export MAKEFLAGS=-j$(nproc)
EOF

source ~/.bashrc

powerprofilesctl set performance

mkdir -v $LFS/sources
chmod -v a+wt $LFS/sources
cd $LFS/sources

wget https://www.linuxfromscratch.org/lfs/view/stable-systemd/wget-list-systemd
wget --input-file=wget-list-systemd --continue --directory-prefix=$LFS/sources

wget https://www.linuxfromscratch.org/lfs/view/stable-systemd/md5sums
pushd $LFS/sources
    md5sum -c md5sums
popd