#!/bin/bash

set -eu

SCRIPT_DIR="$(dirname "$(readlink -f "$0")")"

# install desktop base
sh $SCRIPT_DIR/desktop.sh

# gnome specific
sudo dnf install -y pipx gnome-tweaks
sh $SCRIPT_DIR/../gnome.sh

# flatpaks
sh $SCRIPT_DIR/../flatpak.sh --gnome

echo "Done - Gnome desktop is ready to use"
