#!/usr/bin/env bash

set -x #echo on

set -euo pipefail

HOSTNAME="machine"

echo ">>> Timezone and clock..."
ln -sf "/usr/share/zoneinfo/America/Maceio" /etc/localtime
hwclock --systohc

echo ">>> Locale..."
sed -i "s/^#en_US.UTF-8/en_US.UTF-8/" /etc/locale.gen
sed -i "s/^#pt_BR.UTF-8/pt_BR.UTF-8/" /etc/locale.gen
locale-gen

# echo "LANG=en_US.UTF-8" > /etc/locale.conf
cat >> /etc/locale.conf << EOF
LANG=en_US.UTF-8
LC_ADDRESS=pt_BR.UTF-8
LC_IDENTIFICATION=pt_BR.UTF-8
LC_MEASUREMENT=pt_BR.UTF-8
LC_MONETARY=pt_BR.UTF-8
LC_NAME=pt_BR.UTF-8
LC_NUMERIC=pt_BR.UTF-8
LC_PAPER=pt_BR.UTF-8
LC_TELEPHONE=pt_BR.UTF-8
LC_TIME=pt_BR.UTF-8
EOF

echo "KEYMAP=us-intl" > /etc/vconsole.conf

echo ">>> Hostname..."
echo "$HOSTNAME" > /etc/hostname
cat > /etc/hosts <<EOF
127.0.0.1   localhost
::1         localhost
127.0.1.1   ${HOSTNAME}.localdomain ${HOSTNAME}
EOF