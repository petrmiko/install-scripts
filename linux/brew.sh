#!/bin/bash
set -eu

if [ ! -d "/home/linuxbrew/.linuxbrew" ]; then
    echo "Installing brew"
    NONINTERACTIVE=1 /bin/bash -c "sudo $(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"

    brew install mise starship
fi
