#!/bin/bash

set -eu

SCRIPT_DIR="$(dirname "$(readlink -f "$0")")"

sudo dnf update -y

# build utils and dependencies
sudo dnf install -y @c-development openssl-devel \
    ncurses \
    glibc-langpack-cs

# console utils
sudo dnf install --skip-unavailable -y stow \
    git tig \
    eza \
    fd-find fzf ripgrep tmux zoxide \
    fastfetch \
    duf \
    btop htop \
    bat nano micro jq \
    postgresql \
    zsh

# enable RPM Fusion
sudo dnf install -y \
    https://download1.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm \
    https://download1.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm

# fetch tools not present in fedora repos
if [ ! -d "$HOME/.oh-my-zsh" ]; then
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended --keep-zshrc
fi

if [ ! -d "$HOME/.local/share/fnm" ]; then
    curl -fsSL https://fnm.vercel.app/install | bash -s -- --install-dir "$HOME/.local/share/fnm" --skip-shell
fi

if ! command -v starship --version 2>&1 >/dev/null; then
    curl -sS https://starship.rs/install.sh | sh -s -- --yes
else
    echo "Starship is already installed"
fi

# Rust
if ! command -v cargo --version 2>&1 >/dev/null; then
    curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
    $HOME/.cargo/bin/cargo install cargo-update eza
else
    rustup upgrade
    cargo install-update -a
    echo "Rust is already installed"
fi

# dotfiles
echo "Applying dotfiles"
if [ -d "$HOME/.dotfiles" ]; then
    pushd $HOME/.dotfiles
    git pull --rebase
else
    git clone https://github.com/petrmiko/dotfiles.git $HOME/.dotfiles
    rm $HOME/.zprofile $HOME/.zshrc || true
    pushd $HOME/.dotfiles
fi
stow zsh \
    git \
    fastfetch \
    starship \
    tmux

sudo rm /etc/dnf/dnf.conf
sudo stow -t / dnf
popd

# tmux plugins
if [ ! -d "$HOME/.tmux/plugins/tpm" ]; then
    echo "Installing Tmux Plugin Manager"
    git clone https://github.com/tmux-plugins/tpm $HOME/.tmux/plugins/tpm
fi

# change shell
if [ ! "$SHELL" == "/usr/bin/zsh" ]; then
    echo "Changing shell to ZSH"
    chsh -s /usr/bin/zsh
fi

# fonts
sh $SCRIPT_DIR/../fonts.sh
