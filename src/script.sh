#!/bin/bash

set -e
set -o pipefail

brew_install() {
    brew list --formula "$1" &>/dev/null && printf "\e[93m%s\e[m\n" "$1 already installed, skipping." || brew install "$1"
}

brew_install_cask() {
    brew list --cask "$1" &>/dev/null && printf "\e[93m%s\e[m\n" "$1 already installed, skipping." || brew install --cask "$1"
}

# Install brew
if ! hash brew 2>/dev/null; then
    printf ">\tInstalling brew\n"
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    eval "$(/opt/homebrew/bin/brew shellenv)"
    brew update
else
    printf "\e[93m%s\e[m\n" "You already have brew installed."
    eval "$(/opt/homebrew/bin/brew shellenv)"
fi

# Install CURL / WGET
printf ">\tInstalling CURL/WGET\n"
brew_install curl
brew_install wget

# Install GIT
printf ">\tInstalling git\n"
brew_install git

# Install ZSH
printf ">\tInstalling ZSH\n"
brew_install zsh
brew_install zsh-completions

# Install Oh My ZSH
printf ">\tInstalling Oh My ZSH\n"
[ -d "$HOME/.oh-my-zsh" ] && printf "\e[93m%s\e[m\n" "Oh My ZSH already installed, skipping." || \
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended

# Install ZSH plugins as Oh My ZSH custom plugins
printf ">\tInstalling ZSH plugins\n"
[ -d "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/zsh-autosuggestions" ] && \
    printf "\e[93m%s\e[m\n" "zsh-autosuggestions already installed, skipping." || \
    git clone https://github.com/zsh-users/zsh-autosuggestions "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/zsh-autosuggestions"
[ -d "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting" ] && \
    printf "\e[93m%s\e[m\n" "zsh-syntax-highlighting already installed, skipping." || \
    git clone https://github.com/zsh-users/zsh-syntax-highlighting.git "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting"

# Install oh-my-posh
printf ">\tInstalling oh-my-posh\n"
brew_install oh-my-posh

# Install iTerm2
printf ">\tInstalling terminal tools\n"
brew_install_cask iterm2
brew_install_cask ghostty

# Install command line tools
printf ">\tInstalling CLI tools\n"
brew_install vim
brew_install lsd
brew_install tree
brew_install jq
brew_install fzf
brew_install ripgrep
brew_install gh

# Browsers
printf ">\tInstalling browsers\n"
brew_install_cask google-chrome
brew_install_cask firefox
brew_install_cask arc

# Spotify
brew_install_cask spotify

# Productivity
printf ">\tInstalling Productivity Apps\n"
brew_install_cask notion
brew_install_cask notion-calendar
brew_install_cask notion-mail
brew_install_cask slack
brew_install_cask rectangle
brew_install_cask postman
brew_install_cask raycast

# IDEs
printf ">\tInstalling IDEs\n"
brew_install_cask visual-studio-code
brew_install_cask cursor
brew_install_cask zed
brew_install_cask gitbutler

# Apps
printf ">\tInstalling Apps\n"
brew_install_cask claude
brew_install_cask discord
brew_install_cask 1password
brew_install 1password-cli

# Languages
printf ">\tInstalling languages\n"
brew_install nvm
mkdir -p "$HOME/.nvm"
brew_install pnpm

brew tap oven-sh/bun
brew_install bun

# Install Docker
printf ">\tInstalling Docker\n"
brew_install_cask docker

# Install Logitech Options
printf ">\tInstalling Logitech Options\n"
brew_install_cask logi-options-plus

# Fonts
printf ">\tInstalling fonts\n"
brew_install_cask font-jetbrains-mono-nerd-font

# macOS defaults
printf ">\tConfiguring macOS defaults\n"
defaults write com.apple.dock autohide -bool true
defaults write NSGlobalDomain KeyRepeat -int 2
defaults write NSGlobalDomain InitialKeyRepeat -int 15
defaults write com.apple.finder AppleShowAllFiles -bool true
defaults write com.apple.screencapture disable-shadow -bool true
killall Dock Finder

# Copy .zshrc template (overwrites the one created by Oh My ZSH)
printf ">\tSetting up .zshrc\n"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cp "$SCRIPT_DIR/zshrc.template" "$HOME/.zshrc"

# Git configuration
printf ">\tConfiguring git\n"
read -r -p "Git name: " git_name
read -r -p "Git email: " git_email
git config --global user.name "$git_name"
git config --global user.email "$git_email"
git config --global init.defaultBranch main

# SSH key
printf ">\tGenerating SSH key\n"
ssh-keygen -t ed25519 -C "$git_email"
eval "$(ssh-agent -s)"
ssh-add ~/.ssh/id_ed25519
printf "\nYour public SSH key (add to GitHub):\n"
cat ~/.ssh/id_ed25519.pub

printf "\n\e[92mSetup complete! Restart your terminal.\e[m\n"
