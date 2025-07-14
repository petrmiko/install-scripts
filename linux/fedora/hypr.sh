#!/bin/bash

set -eu

SCRIPT_DIR="$(dirname "$(readlink -f "$0")")"

# install common base
sh $SCRIPT_DIR/desktop.sh

sudo dnf copr enable solopasha/hyprland -y

sudo dnf install -y hyprland \
    wofi \
    network-manager-applet \
    polkit hyprpolkitagent \
    pipewire-pulse pavucontrol

# facing vulkan errors with nautilus on Asahi
sudo dnf install -y dolphin

# for GTK dark theme
sudo dnf install -y adw-gtk3-theme

# dotfiles
echo "Applying additional dotfiles"
pushd $HOME/.dotfiles
stow hypr || true # once hypr takes over we cannot restow
popd