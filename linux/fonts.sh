#!/bin/bash

set -eu
TMP_FONTS_DIR=$(mktemp -d -t install_fonts_XXXXXX)

echo "Installing Nerd fonts (tmp dir: $TMP_FONTS_DIR)"
trap "rm -rf '$TMP_FONTS_DIR'" EXIT
mkdir -p "$HOME/.local/share/fonts"

if [ ! -f "$HOME/.local/share/fonts/FiraCodeNerdFont-Regular.ttf" ]; then
    echo "Fetching FiraCode..." && wget -q --directory-prefix=$TMP_FONTS_DIR https://github.com/ryanoasis/nerd-fonts/releases/latest/download/FiraCode.zip
else
    echo "FiraCode already installed..."
fi
if [ ! -f "$HOME/.local/share/fonts/JetBrainsMonoNerdFont-Regular.ttf" ]; then
    echo "Fetching JetBrainsMono..." && wget -q --directory-prefix=$TMP_FONTS_DIR https://github.com/ryanoasis/nerd-fonts/releases/latest/download/JetBrainsMono.zip
else
    echo "JetBrainsMono already installed..."
fi
if [ ! -z "$( ls -A $TMP_FONTS_DIR )" ]; then
    echo "Unpacking fonts..."
    unzip -q -o "$TMP_FONTS_DIR/*.zip" -d "$TMP_FONTS_DIR"
    mv -f -t "$HOME/.local/share/fonts" $TMP_FONTS_DIR/*.ttf
    echo "Rebuilding font cache..."
    fc-cache
fi
