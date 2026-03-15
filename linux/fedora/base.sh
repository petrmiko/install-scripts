#!/bin/bash

set -eu

sudo dnf update -y --no-best

# build utils and dependencies
sudo dnf install -y @c-development openssl-devel \
    ncurses procps-ng curl file \
    glibc-langpack-cs

# console utils
sudo dnf install --skip-unavailable -y stow \
    git tig \
    eza \
    fd-find fzf ripgrep tmux zoxide \
    fastfetch \
    duf \
    btop htop \
    bat nano neovim micro jq \
    newt \
    postgresql \
    tealdeer \
    zsh \
    zsh-syntax-highlighting

# enable RPM Fusion
sudo dnf install -y \
    https://download1.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm \
    https://download1.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm

# fetch tools outside of fedora repos
if [ ! -d "/home/linuxbrew/.linuxbrew" ]; then
    echo "Installing brew"
    NONINTERACTIVE=1 /bin/bash -c "sudo $(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"

    ## TODO replace with Brewfile
    brew install mise starship
fi

if [ ! -d "$HOME/.oh-my-zsh" ]; then
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended --keep-zshrc
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
    mise \
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

# Tailscale
if ! command -v tailscale --version 2>&1 >/dev/null; then
    if (whiptail --title "Tailscale" --yesno "Do you want to install Tailscale?\nAlert: needs to register device via browser!" --defaultno 8 78); then
        sudo dnf config-manager addrepo --overwrite --from-repofile=https://pkgs.tailscale.com/stable/fedora/tailscale.repo
        sudo dnf install tailscale -y
        sudo systemctl enable --now tailscaled
        sudo tailscale up
    else
        echo "Tailscale not requested, skipping installation"
    fi
else
    echo "Tailscale is already installed"
fi

echo "Done - Base install is ready to use"
