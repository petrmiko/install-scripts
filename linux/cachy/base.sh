#!/bin/bash

set -eu

sudo pacman -S --noconfirm stow \
    bat htop eza zoxide teeldear \
    mise \
    nvtop s-tui \
    podman rustup tig tmux \
    starship zsh-syntax-highlighting \
    tailscale \
    ttf-jetbrains-mono-nerd ttf-firacode-nerd

rustup default stable
