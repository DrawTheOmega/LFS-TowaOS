#!/bin/bash

cat > ~/.bashrc << "EOF"
umask 022
export LFS=/mnt/lfs
export MAKEFLAGS=-j$(nproc)
EOF

source ~/.bashrc

powerprofilesctl set performance

apt update -y
apt upgrade -y

apt install -y build-essential bison gawk m4 texinfo wget curl git
ln -svf /bin/bash /bin/sh
