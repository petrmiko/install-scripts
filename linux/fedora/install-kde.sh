#!/bin/bash

set -eu

SCRIPT_DIR="$(dirname "$(readlink -f "$0")")"

# install desktop base
sh $SCRIPT_DIR/desktop.sh

# kde specific
sudo dnf install -y okular skanpage

# flatpaks
sh $SCRIPT_DIR/../flatpak.sh --kde

echo "Done - KDE desktop is ready to use"
