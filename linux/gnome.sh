#!/bin/bash

set -eu

PATH="$HOME/.local/bin:$PATH"

gsettings set org.gnome.desktop.interface icon-theme 'Papirus'
gsettings set org.gnome.desktop.wm.preferences button-layout 'icon:minimize,maximize,close'
gsettings set org.gnome.desktop.interface monospace-font-name 'JetBrainsMono Nerd Font 13'

if ! command -v gext --version 2>&1 >/dev/null; then
    pipx install gnome-extensions-cli --system-site-packages
fi

# every extension id can be opened in URL by https://extensions.gnome.org/extension/<id>
gnome_extensions=(
    4944 # App Icons Taskbar
    615 # AppIndicator and KStatusNotifierItem Support 
    3193 # Blur My Shell
    3843 # Just perfection
    5112 # Tailscale status
    1460 # vitals
)

echo "Installing Gnome extensions"
gext --dbus install ${gnome_extensions[@]}
gext --dbus enable ${gnome_extensions[@]}

# start on Desktop, not Overview
dconf write /org/gnome/shell/extensions/just-perfection/startup-status 0
