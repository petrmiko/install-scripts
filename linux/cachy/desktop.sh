#!/bin/bash

set -eu

SCRIPT_DIR="$(dirname "$(readlink -f "$0")")"

sudo pacman -S --noconfirm flatpak fuse2 \
    ghostty \
    okular skanpage \
    vlc
paru -S --noconfirm 1password visual-studio-code-bin

# flatpaks
sh $SCRIPT_DIR/../flatpak.sh --kde
