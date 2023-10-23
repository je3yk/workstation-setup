#!/bin/bash

INSTAL_DIR=/.setup
mkdir -p $INSTAL_DIR
SETUP_PROFILE=$INSTAL_DIR/setup_profile


# Install brew
if ! hash brew
then
    printf ">\tInstalling brew\n"
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh)"
    brew update
else
    printf "\e[93m%s\e[m\n" "You already have brew installed.\n"
fi

# Install CURL / WGET
printf ">\tInstalling CURL/WGET\n"
brew install curl
brew install wget

{
    # shellcheck disable=SC2016
    echo 'export PATH="/usr/local/opt/curl/bin:$PATH"'
    # shellcheck disable=SC2016
    echo 'export PATH="/usr/local/opt/openssl@1.1/bin:$PATH"'
    # shellcheck disable=SC2016
    echo 'export PATH="/usr/local/opt/sqlite/bin:$PATH"'
}>>$SETUP_PROFILE

# Install GIT
printf ">\tInstalling git\n"
brew install git

# Install ZSH
brew install zsh zsh-completions
sudo chmod -R 755 /usr/local/share/zsh
sudo chmod -R root:staff /usr/local/share/zsh

{
    echo "if type brew &>/dev/null; then"
    echo " FPATH=$(brew --prefix)/share/zsh/site-functions:$FPATH"
    echo " autoload -Uz compinit"
    echo " compinit"
    echo "fi"
}>>$SETUP_PROFILE

# Install Oh My ZSH
printf ">\tInstalling Oh My ZSH\n"
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

# Install Powerlevel10k

# Install Iterm2
printf ">\tInstalling terminal tools\n"
brew install --cask iterm2

# Install command line tools
brew install micro
brew install vim
brew install lsd
{
    echo "alias ls='lsd'"
    echo "alias l='ls -l'"
    echo "alias la='ls -a'"
    echo "alias lla='ls -la'"
    echo "alias lt='ls --tree'"
    echo "alias zshconfig='vim ~/.zsh_profile'"
}>>$SETUP_PROFILE

brew install tree
brew install ack
brew install bash-completion
brew install jq
brew install zsh-autosuggestions
brew install zsh-autocomplete


# Browsers
brew install --cask google-chrome
brew install --cask firefox
brew install --cask brave-browser

# Install Spotify
brew install --cask spotify

# Productivity
printf ">\tInstalling Productivity Apps\n"
brew install --cask notion
brew install --cask slack
brew install --cask whatsapp
brew install --cask cron
brew install --cask rectangle
brew install --cask postman

# IDE
printf ">\tInstalling IDEs\n"
brew install --cask visual-studio-code

# Languages
## JavaScript
printf ">\tInstalling NodeJS\n"
brew install node
brew install yarn
brew install pnpm

# Install Docker
printf ">\tInstalling Docker\n"
brew install --cask docker
brew install docker-completion
brew install docker-compose-completion
brew install docker-machine-completion


# reload profile items
{
    echo "source $SETUP_PROFILE # alias and things added by setup script"

}>>"$HOME/.zsh_profile"
# shellcheck disable=SC1090
source "$HOME/.zsh_profile"

{
    echo "source $SETUP_PROFILE # alias and things added by setup script"
}>>~/.bash_profile
# shellcheck disable=SC1090
source ~/.bash_profile