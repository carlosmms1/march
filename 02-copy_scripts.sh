#!/usr/bin/env bash

set -x #echo on

set -euo pipefail

echo ">>> Copying configuration scripts to chroot..."
cp *.sh /mnt/root/