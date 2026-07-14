#!/usr/bin/env bash

set -x #echo on

set -euo pipefail

DISK="/dev/sda"
EFI_SIZE="512MiB"
SWAP_SIZE="8GiB"

[[ -b "$DISK" ]] || {
    echo "Error: device '$DISK' not found."
    exit 1
}

echo ">>> Verifying boot mode ([UEFI] should return 64)..."
cat /sys/firmware/efi/fw_platform_size || { 
    echo "System isn't UEFI mode. Aborting..." 
    exit 1
}

echo ">>> Syncing clock..."
timedatectl set-ntp true

if [[ "$DISK" == *"nvme"* ]]; then
    PART_SUFFIX="p"
else
    PART_SUFFIX=""
fi
EFI_PART="${DISK}${PART_SUFFIX}1"
SWAP_PART="${DISK}${PART_SUFFIX}2"
ROOT_PART="${DISK}${PART_SUFFIX}3"

echo
echo "========================================"
echo "WARNING!"
echo "ALL the data at '$DISK' will be erased."
echo "========================================"
echo

lsblk -o NAME,SIZE,MODEL,FSTYPE,MOUNTPOINT "$DISK"
echo

read -rp "Type '$DISK' to confirm: " CONFIRM

if [[ "$CONFIRM" != "$DISK" ]]; then
    echo "Aborting..."
    exit 1
fi

echo ">>> Partitioning $DISK (GPT: EFI + swap + root ext4)..."
sgdisk --zap-all "$DISK"
sgdisk -n 1:0:+${EFI_SIZE} -t 1:ef00 -c 1:EFI "$DISK"
sgdisk -n 2:0:+${SWAP_SIZE} -t 2:8200 -c 2:swap "$DISK"
sgdisk -n 3:0:0            -t 3:8300 -c 3:root "$DISK"
partprobe "$DISK"

echo ">>> Formatting patitions..."
mkfs.fat -F32 -n EFI "$EFI_PART"
mkswap -L swap "$SWAP_PART"
mkfs.ext4 -L root "$ROOT_PART"
 
echo ">>> Mounting partitions..."
mount "$ROOT_PART" /mnt
mkdir -p /mnt/boot
mount "$EFI_PART" /mnt/boot
swapon "$SWAP_PART"