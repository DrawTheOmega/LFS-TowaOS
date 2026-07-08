#!/bin/bash

apt update -y
apt upgrade -y

apt install -y build-essential bison gawk m4 texinfo wget curl git
ln -svf /bin/bash /bin/sh
