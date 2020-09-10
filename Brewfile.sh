#!/bin/bash

which brew || /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh)"
brew update

# Update already-installed formula (takes too much time, I will do it manually later)
# brew upgrade

# Add Repository
# brew tap homebrew/versions || true
# brew tap homebrew/binary || true
# brew tap sonots/mycask || true
brew tap phinze/homebrew-cask || true

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
brew install direnv
brew install jq
# brew install coreutils --default-names # http://takuya-1st.hatenablog.jp/entry/20111230/1325272152
# brew install imagemagick
# brew install packer
brew install brew-cask
# kubernetes
brew install kubectl
brew install krew
brew install kustomize
brew install k9s
# golang
brew install golang
# go get github.com/peco/peco/cmd/peco
# go get github.com/motemen/ghq
# java
brew install jenv

# .dmg with homebrew-cask
brew cask install google-chrome
# brew cask install firefox
# brew cask install vivaldi
# brew cask install evernote
# brew cask install dropbox
# brew cask install skype
brew cask install iterm2
# brew cask install limechat
# brew cask install sublime-text
# brew cask install marked2
# brew cask install xquartz
# brew cask install wireshark
# brew cask install kobito
# brew cask install virtualbox
# brew cask install vagrant
# brew cask install karabiner
# brew cask install echofon # mycask
# brew cask install cot-editor # mycask
# brew cask install macvim-kaoriya # mycask
# brew cask install gyazo # mycask
# brew install neovim
brew cask install visual-studio-code

# Remove outdated versions
brew cleanup
