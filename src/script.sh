#!/bin/bash

set -e
set -o pipefail

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
brew install curl
brew install wget

# Install GIT
printf ">\tInstalling git\n"
brew install git

# Install ZSH
printf ">\tInstalling ZSH\n"
brew install zsh zsh-completions

# Install Oh My ZSH
printf ">\tInstalling Oh My ZSH\n"
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended

# Install ZSH plugins as Oh My ZSH custom plugins
printf ">\tInstalling ZSH plugins\n"
git clone https://github.com/zsh-users/zsh-autosuggestions "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/zsh-autosuggestions"
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting"

# Install oh-my-posh
printf ">\tInstalling oh-my-posh\n"
brew install oh-my-posh

# Install iTerm2
printf ">\tInstalling terminal tools\n"
brew install --cask iterm2
brew install --cask ghostty

# Install command line tools
printf ">\tInstalling CLI tools\n"
brew install vim
brew install lsd
brew install tree
brew install jq
brew install fzf
brew install ripgrep
brew install gh

# Browsers
printf ">\tInstalling browsers\n"
brew install --cask google-chrome
brew install --cask firefox
brew install --cask arc

# Spotify
brew install --cask spotify

# Productivity
printf ">\tInstalling Productivity Apps\n"
brew install --cask notion
brew install --cask notion-calendar
brew install --cask notion-mail
brew install --cask slack
brew install --cask rectangle
brew install --cask postman
brew install --cask raycast

# IDEs
printf ">\tInstalling IDEs\n"
brew install --cask visual-studio-code
brew install --cask cursor
brew install --cask zed
brew install --cask gitbutler

# Apps
printf ">\tInstalling Apps\n"
brew install --cask claude
brew install --cask discord
brew install --cask 1password
brew install 1password-cli

# Languages
printf ">\tInstalling languages\n"
brew install nvm
mkdir -p "$HOME/.nvm"
brew install pnpm
brew install bun

# Install Docker
printf ">\tInstalling Docker\n"
brew install --cask docker

# Install Logitech Options
printf ">\tInstalling Logitech Options\n"
brew install --cask logi-options-plus

# Fonts
printf ">\tInstalling fonts\n"
brew install --cask font-jetbrains-mono-nerd-font

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
