#!/bin/bash

which brew || /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh)"
brew update

# Update already-installed formula (takes too much time, I will do it manually later)
# brew upgrade

# Add Repository
# brew tap homebrew/versions || true
# brew tap homebrew/binary || true
# brew tap sonots/mycask || true

# Packages

brew install vim
brew install zsh
brew install git
brew install gist
brew install tig
brew install tmux
brew install ctags
brew install nkf
brew install lv
brew install htop
brew install wget
brew install tree
brew install pkg-config
brew install libtool
brew install cmake
brew install autoconf
brew install automake
brew install mosh
brew install markdown
brew install pstree
brew install pidof # pidof
brew install proctools # pkill, pgrep, pfind
brew install rmtrash # `rmtrash` moves file to Trash
brew install ag
brew install rbenv ruby-build
brew install readline
brew install ghq
brew install peco
brew install fzf
brew install direnv
brew install jq
brew install coreutils # gdate, gsed
# brew install coreutils --default-names # http://takuya-1st.hatenablog.jp/entry/20111230/1325272152
# brew install imagemagick
# brew install packer
# kubernetes
brew install kubectl
brew install krew
brew install kustomize
brew install k9s
brew install --cask lens
# golang
brew install golang
# java
brew install jenv

# Install .dmg by homebrew-cask
brew install --cask karabiner-elements
brew install --cask google-chrome
# brew install --cask firefox
brew install --cask  iterm2
# brew install --cask  xquartz
# brew install --cask  wireshark
# brew install --cask  virtualbox
# brew install --cask  vagrant
brew install --cask visual-studio-code
brew install --cask skitch
brew install --cask discord
brew install --cask slack
brew install --cask kindle

# Remove outdated versions
brew cleanup
