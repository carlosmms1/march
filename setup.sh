#!/usr/bin/env bash

set -x #echo on

set -euo pipefail

echo ">>> Starting arch installation..."

( ./00-prepare.sh      )                           |& tee 00-prepare.log
( ./01-foundation.sh   )                           |& tee 01-foundation.log
( ./02-copy_scripts.sh )                           |& tee 02-copy_scripts.log
( arch-chroot /mnt /root/03-configuration.sh )     |& tee 03-configuration.log
( arch-chroot /mnt /root/04-user.sh )              |& tee 04-user.log
( arch-chroot /mnt /root/05-bootloader.sh )        |& tee 05-bootloader.log
( arch-chroot /mnt /root/06-zram.sh )              |& tee 06-zram.log
( arch-chroot /mnt /root/07-softwares.sh )         |& tee 07-softwares.log
( arch-chroot /mnt /root/99-post_installation.sh ) |& tee 99-post_installation.log
mkdir -p /mnt/home/cmms/setup-logs
cp -v *.log /mnt/home/cmms/setup-logs/
chown -R 1000:1000 /mnt/home/cmms/setup-logs/

echo ">>> Arch installation finished!"