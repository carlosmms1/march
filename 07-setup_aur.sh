#!/usr/bin/env bash

set -x #echo on

set -euo pipefail

echo ">>> Updating packages metadata..."
pacman -Syy

echo ">>> Building yay from PKGBUILD..."
git clone https://aur.archlinux.org/yay.git
cd yay
makepkg -si
