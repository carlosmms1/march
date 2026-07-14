#!/usr/bin/env bash

set -x #echo on

set -euo pipefail

echo ">>> Enabling NetworkManager..."
systemctl enable NetworkManager

echo ">>> Enabling sddm..."
systemctl enable sddm

echo ">>> Enabling profiles daemon..."
systemctl enable power-profiles-daemon