#!/bin/bash
set -e

# After install: Oh my zsh, JDK, Android Studio, XCode, FVM then add settings to .zshrc
: '
export GOPATH=$HOME/go
export PATH=$PATH:$GOROOT/bin:$GOPATH/bin

#SQLite settings.
export LDFLAGS="-L/usr/local/opt/sqlite/lib"
export CPPFLAGS="-I/usr/local/opt/sqlite/include"
export PKG_CONFIG_PATH="/usr/local/opt/sqlite/lib/pkgconfig"

export GEM_HOME=$HOME/.gem
export PATH=$GEM_HOME/bin:$PATH

# encode for fastlane.
export LC_ALL=en_US.UTF-8
export LANG=en_US.UTF-8

#Flutter Settings
export PATH=$HOME/fvm/default/bin:$PATH
export PATH="$PATH":"$HOME/.pub-cache/bin"
export FLUTTER_ROOT=$HOME/fvm/default
export PATH=$FLUTTER_ROOT/bin:$PATH
export PATH=$PATH:$HOME/.pub-cache/bin

export JAVA_HOME=$(/usr/libexec/java_home)
export ANDROID_HOME=$HOME/Library/Android/sdk
export PATH=$PATH:$ANDROID_HOME/cmdline-tools/latest/bin
export PATH=$PATH:$ANDROID_HOME/tools
export PATH=$PATH:$ANDROID_HOME/platform-tools
'

# install go -> go install github.com/google/addlicense@latest
# 1. melos
# 2. fluttergen
# 3. getx cli
# 4. rbenv => ruby 3++
# 5. install ruby gems + cocoapods
# 6. install flutterfire_cli

#show git log in the same terminal window.
git config --global --replace-all core.pager "less -F -X"
#setup git editor to the nano.
git config --global core.editor "nano"

GREEN_BOLD="\033[1;32m"
RESET_FORMATING="\033[0m"

# Install home brew
#/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

# Install go
brew install go

# Install addlicense
go install github.com/google/addlicense@latest

# Install rbenv
brew install rbenv

# Install ruby
sudo rbenv install 3.4.4

# Install ruby gems
sudo rbenv global 3.4.4

# add rbenv to bash so that it loads every time you open a terminal
echo 'export PATH="$HOME/.rbenv/bin:$PATH"' >> ~/.zshrc
echo 'eval "$(rbenv init -)"' >> ~/.zshrc
source ~/.zshrc

ruby -v

# Install Melos
dart pub global activate melos

# Install FlutterGen
dart pub global activate flutter_gen

# Install GetX CLI
dart pub global activate get_cli

# Install ruby gems
gem install bundler

# Install cocoapods
gem install cocoapods

# Run this one before running pod install.
fvm flutter precache --ios

# Install flutterfire_cli
dart pub global activate flutterfire_cli

fvm flutter pub get

melos installGitTools

echo -e "\033[7;32m                                       \033[0m"
echo -e "\033[7;32m Dev Tools are installed!!!            \033[0m"
echo -e "\033[7;32m                                       \033[0m"
