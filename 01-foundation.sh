#!/usr/bin/env bash

set -x #echo on

set -euo pipefail

# to avoid failures of the shape
# signature from "..." is invalid
# File ... is corrupted (invalid or corrupted package (PGP signature))
pacman -S --noconfirm archlinux-keyring

echo ">>> Enabling mirrors (reflector, if available) and multilib..."
if command -v reflector &>/dev/null; then
    reflector --country Brazil \
        --age 24 \
        --fastest 5 \
        --latest 10 \
        --sort rate \
        --protocol https \
        --save /etc/pacman.d/mirrorlist || true
fi

echo ">>> Updating packages metadata..."
pacman -Syy

echo ">>> Installing base system (pacstrap)..."
pacstrap -K /mnt \
    base base-devel linux linux-firmware linux-headers \
    intel-ucode \
    networkmanager \
    grub efibootmgr \
    sudo vim nano git wget curl \
    man-db man-pages texinfo \
    reflector

echo ">>> Generating fstab..."
genfstab -U /mnt >> /mnt/etc/fstab

# Assign a low priority (10) to the disk swap so that zram (priority 100,
# configured inside the chroot) is always filled first by the kernel.
sed -i '/swap/ s/defaults 0 0/defaults,pri=10 0 0/' /mnt/etc/fstab