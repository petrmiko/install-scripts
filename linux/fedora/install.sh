#!/bin/bash

set -eu

SCRIPT_DIR="$(dirname "$(readlink -f "$0")")"

# install desktop base
sh $SCRIPT_DIR/desktop.sh

# flatpaks
sh $SCRIPT_DIR/../flatpak.sh

# gnome specific
sudo dnf install -y pipx gnome-tweaks
sh $SCRIPT_DIR/../gnome.sh

echo "Done - Gnome desktop is ready to use"
