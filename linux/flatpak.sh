#!/bin/bash

set -eu

echo "Installing flatpaks"
flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo
flatpak install -y --or-update \
    io.beekeeperstudio.Studio \
    io.podman_desktop.PodmanDesktop

case "${1:-}" in
    --gnome)
	    flatpak install -y --or-update \
	        com.mattjakeman.ExtensionManager \
	        com.github.tchx84.Flatseal \
	        io.missioncenter.MissionCenter
        ;;
    --kde)
        echo "No additional apps for KDE"
        ;;
    *)
        echo "Usage: sh flatpak.sh [--gnome|--kde]"
        exit 1
        ;;
esac
