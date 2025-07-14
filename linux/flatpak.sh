#!/bin/bash

set -eu

echo "Installing flatpaks"
flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo
flatpak install -y --or-update \
    com.mattjakeman.ExtensionManager \
    com.github.tchx84.Flatseal \
    io.beekeeperstudio.Studio \
    io.missioncenter.MissionCenter \
    io.podman_desktop.PodmanDesktop
