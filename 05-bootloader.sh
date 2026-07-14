#!/usr/bin/env bash

set -x #echo on

set -euo pipefail

echo ">>> mkinitcpio (regenerating initramfs)..."
mkinitcpio -P

echo ">>> Installing and configuring GRUB (UEFI)..."
grub-install --target=x86_64-efi --efi-directory=/boot --bootloader-id=Arch
grub-mkconfig -o /boot/grub/grub.cfg