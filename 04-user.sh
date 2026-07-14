#!/usr/bin/env bash

set -x #echo on

set -euo pipefail

USERNAME="cmms"

echo ">>> Creating user and setting up sudo..."
useradd -m -G wheel,video,audio,input,storage,optical -s /bin/bash "$USERNAME"
echo ">>> Define username password ($USERNAME):"
passwd "$USERNAME"
sed -i 's/^# %wheel ALL=(ALL:ALL) ALL/%wheel ALL=(ALL:ALL) ALL/' /etc/sudoers