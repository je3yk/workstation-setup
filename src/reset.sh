#!/bin/bash

set -e
set -o pipefail

brew_install() {
    brew list --formula "$1" &>/dev/null && printf "\e[93m%s\e[m\n" "$1 already installed, skipping." || brew install "$1"
}

brew_install_cask() {
    brew list --cask "$1" &>/dev/null && printf "\e[93m%s\e[m\n" "$1 already installed, skipping." || brew install --cask "$1"
}

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Ensure brew is available
eval "$(/opt/homebrew/bin/brew shellenv)"

# Update & upgrade all packages
printf ">\tUpdating Homebrew and upgrading all packages\n"
brew update
brew upgrade
brew upgrade --cask
brew cleanup

# Ensure all declared packages are installed
printf ">\tEnsuring all declared packages are installed\n"
brew_install curl
brew_install wget
brew_install git
brew_install zsh
brew_install zsh-completions
brew_install oh-my-posh
brew_install vim
brew_install lsd
brew_install tree
brew_install jq
brew_install fzf
brew_install ripgrep
brew_install gh
brew_install nvm
brew_install pnpm
brew tap oven-sh/bun
brew_install bun
brew_install 1password-cli

brew_install_cask iterm2
brew_install_cask ghostty
brew_install_cask google-chrome
brew_install_cask firefox
brew_install_cask arc
brew_install_cask spotify
brew_install_cask notion
brew_install_cask notion-calendar
brew_install_cask notion-mail
brew_install_cask slack
brew_install_cask rectangle
brew_install_cask postman
brew_install_cask raycast
brew_install_cask visual-studio-code
brew_install_cask cursor
brew_install_cask zed
brew_install_cask gitbutler
brew_install_cask claude
brew_install_cask discord
brew_install_cask 1password
brew_install_cask docker
brew_install_cask logi-options-plus
brew_install_cask font-jetbrains-mono-nerd-font

# Ensure Oh My ZSH is installed
printf ">\tChecking Oh My ZSH\n"
[ -d "$HOME/.oh-my-zsh" ] && printf "\e[93m%s\e[m\n" "Oh My ZSH already installed, skipping." || \
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended

# Ensure ZSH plugins are installed
printf ">\tChecking ZSH plugins\n"
[ -d "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/zsh-autosuggestions" ] && \
    printf "\e[93m%s\e[m\n" "zsh-autosuggestions already installed, skipping." || \
    git clone https://github.com/zsh-users/zsh-autosuggestions "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/zsh-autosuggestions"
[ -d "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting" ] && \
    printf "\e[93m%s\e[m\n" "zsh-syntax-highlighting already installed, skipping." || \
    git clone https://github.com/zsh-users/zsh-syntax-highlighting.git "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting"

# SSH key
printf ">\tChecking SSH keys\n"
if ls ~/.ssh/id_* &>/dev/null 2>&1; then
    printf "\e[93m%s\e[m\n" "SSH key already exists, skipping."
else
    printf ">\tGenerating SSH key\n"
    read -r -p "Email for SSH key: " ssh_email
    ssh-keygen -t ed25519 -C "$ssh_email"
    eval "$(ssh-agent -s)"
    ssh-add ~/.ssh/id_ed25519
    printf "\nYour public SSH key (add to GitHub):\n"
    cat ~/.ssh/id_ed25519.pub
fi

# Reset .zshrc from template
printf ">\tResetting .zshrc from template\n"
cp "$SCRIPT_DIR/zshrc.template" "$HOME/.zshrc"

# Ensure alias target folders exist and append aliases
printf ">\tSetting up folder aliases\n"
mkdir -p "$HOME/Documents/Projects"
printf "\n# Folder aliases\n" >> "$HOME/.zshrc"
cat "$SCRIPT_DIR/aliases.sh" >> "$HOME/.zshrc"

# macOS defaults
printf ">\tApplying macOS defaults\n"
defaults write com.apple.dock autohide -bool true
defaults write NSGlobalDomain KeyRepeat -int 2
defaults write NSGlobalDomain InitialKeyRepeat -int 15
defaults write com.apple.finder AppleShowAllFiles -bool true
defaults write com.apple.screencapture disable-shadow -bool true
killall Dock Finder

# Git configuration
printf ">\tChecking git configuration\n"
git_name=$(git config --global user.name || true)
git_email=$(git config --global user.email || true)

if [ -z "$git_name" ]; then
    read -r -p "Git name: " git_name
    git config --global user.name "$git_name"
else
    printf "\e[93m%s\e[m\n" "Git name already set to '$git_name', skipping."
fi

if [ -z "$git_email" ]; then
    read -r -p "Git email: " git_email
    git config --global user.email "$git_email"
else
    printf "\e[93m%s\e[m\n" "Git email already set to '$git_email', skipping."
fi

git config --global init.defaultBranch main

printf "\n\e[92mReset complete! Restart your terminal.\e[m\n"
