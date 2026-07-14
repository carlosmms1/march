#!/usr/bin/env bash

set -x #echo on

set -euo pipefail

echo ">>> Installing AMD graphic drivers (amdgpu) and Xorg + Wayland stacks..."
# Xorg é mantido porque o Openbox (planejado para o futuro) é X11-only —
# não existe versão Wayland dele. O Plasma funciona nos dois; SDDM oferece
# a escolha da sessão (Plasma/X11, Plasma/Wayland) na tela de login.
pacman -S --noconfirm --needed \
    xorg-server xorg-xinit xorg-xrandr \
    wayland wayland-protocols egl-wayland qt6-wayland xorg-xwayland \
    mesa lib32-mesa \
    vulkan-radeon lib32-vulkan-radeon

echo ">>> Installing KDE Plasma..."
pacman -S --noconfirm --needed \
    plasma-meta konsole dolphin dolphin-plugins \
    kate ark spectacle \
    sddm plasma-nm plasma-pa power-profiles-daemon \
    print-manager


echo ">>> Installing browser (brave)..."
if available pacman; then
    if pacman -Ss brave-browser_release >/dev/null 2>&1; then
        pacman -Sy --needed --noconfirm "brave-browser_release"
    elif
        echo ">>> Skipping browser installation..."
    fi
fi

echo ">>> Installing extras..."
pacman -S --noconfirm --needed \
    noto-fonts noto-fonts-emoji ttf-liberation \
    zsh htop

# Helpers
available() { command -v "${1:?}" >/dev/null; }