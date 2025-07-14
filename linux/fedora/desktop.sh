#!/bin/bash

set -eu

SCRIPT_DIR="$(dirname "$(readlink -f "$0")")"

# install common base
sh $SCRIPT_DIR/base.sh

# fonts
sh $SCRIPT_DIR/../fonts.sh

# gui DNF apps
sudo dnf install -y alacritty firefox solaar

# install HEIF/HEIC libs to see iPhone photos
sudo dnf install -y heif-pixbuf-loader libheif-tools libheif-freeworld 

# icons
sudo dnf install -y papirus-icon-theme

# ghostty
sudo dnf copr enable pgdev/ghostty -y
sudo dnf install ghostty -y

# dotfiles
echo "Applying additional dotfiles"
pushd $HOME/.dotfiles
stow alacritty ghostty
popd

# VS Code
if ! command -v code -v 2>&1 >/dev/null; then
    echo "Installing VS Code"
    sudo rpm --import https://packages.microsoft.com/keys/microsoft.asc
    echo -e "[code]\nname=Visual Studio Code\nbaseurl=https://packages.microsoft.com/yumrepos/vscode\nenabled=1\ngpgcheck=1\ngpgkey=https://packages.microsoft.com/keys/microsoft.asc" | sudo tee /etc/yum.repos.d/vscode.repo > /dev/null
    dnf check-update
    sudo dnf install code -y
else
    echo "VS Code is already installed"
fi

# Tailscale
if ! command -v tailscale --version 2>&1 >/dev/null; then
    sudo dnf config-manager addrepo --overwrite --from-repofile=https://pkgs.tailscale.com/stable/fedora/tailscale.repo
    sudo dnf install tailscale -y
    sudo systemctl enable --now tailscaled
    sudo tailscale up
else
    echo "Tailscale is already installed"
fi

# Zed.dev
if ! command -v zed --version 2>&1 >/dev/null; then
    curl -f https://zed.dev/install.sh | sh
else
    echo "Zed is already installed"
fi

# 1Password
if ! command -v 1password --version 2>&1 >/dev/null; then
    sudo rpm --import https://downloads.1password.com/linux/keys/1password.asc
    sudo sh -c 'echo -e "[1password]\nname=1Password Stable Channel\nbaseurl=https://downloads.1password.com/linux/rpm/stable/\$basearch\nenabled=1\ngpgcheck=1\nrepo_gpgcheck=1\ngpgkey=\"https://downloads.1password.com/linux/keys/1password.asc\"" > /etc/yum.repos.d/1password.repo'
    sudo dnf install 1password -y --skip-unavailable # Asahi not supported yet
    if ! command -v 1password --version 2>&1 >/dev/null; then
        echo "1Password could not be installed, install it manually https://support.1password.com/install-linux/#other-distributions-or-arm-targz"
    fi
else
    echo "1Password is already installed"
fi

echo "Done - Base desktop is ready to use"
