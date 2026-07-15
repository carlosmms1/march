#!/usr/bin/env bash

set -x #echo on

set -euo pipefail

source "$(dirname $0)/helpers.sh"

if available yay; then
    echo ">>> Updating packages metadata..."
    yay -Syy

    echo ">>> Installing AMD graphic drivers (amdgpu) and Xorg + Wayland stacks..."
    # Xorg é mantido porque o Openbox (planejado para o futuro) é X11-only —
    # não existe versão Wayland dele. O Plasma funciona nos dois; SDDM oferece
    # a escolha da sessão (Plasma/X11, Plasma/Wayland) na tela de login.
    yay -Syu --noconfirm --needed \
        xorg-server xorg-xinit xorg-xrandr \
        wayland wayland-protocols egl-wayland qt6-wayland xorg-xwayland \
        mesa lib32-mesa \
        vulkan-radeon lib32-vulkan-radeon

    echo ">>> Installing KDE Plasma..."
    yay -Syu --noconfirm --needed \
        plasma-meta konsole dolphin dolphin-plugins \
        kate ark spectacle \
        sddm plasma-nm plasma-pa power-profiles-daemon \
        print-manager

    echo ">>> Installing browser (brave)..."
    if yay -Ss brave-bin >/dev/null 2>&1; then
        yay -Syu --needed --noconfirm brave-bin
    else
        echo ">>> Skipping browser installation..."
    fi

    echo ">>> Installing extras..."
    yay -Syu --noconfirm --needed \
        noto-fonts noto-fonts-emoji ttf-liberation \
        zsh htop
else
    echo ">>> Skipping softwares installation..."
fi











