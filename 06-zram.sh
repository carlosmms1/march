#!/usr/bin/env bash

set -x #echo on

set -euo pipefail

echo ">>> Installing and configuring zram-generator..."
pacman -S --noconfirm --needed zram-generator

cat > /etc/systemd/zram-generator.conf <<'EOF'
[zram0]
zram-size = ram
compression-algorithm = zstd
swap-priority = 100
fs-type = swap
EOF

cat > /etc/sysctl.d/99-vm-zram-parameters.conf <<'EOF'
vm.swappiness = 180
vm.watermark_boost_factor = 0
vm.watermark_scale_factor = 125
vm.page-cluster = 0
EOF