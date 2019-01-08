#!/bin/bash
# Make sure using latest Homebrew
brew update

# Update already-installed formula (takes too much time, I will do it manually later)
# upgrade

# Add Repository
brew tap homebrew/versions || true
brew tap homebrew/binary || true
brew tap phinze/homebrew-cask || true
brew tap sonots/mycask || true

# Packages

brew install vim
brew install zsh
brew install git
brew install gist
brew install tig
brew install tmux
brew install ack
brew install ctags
brew install nkf
brew install lv
brew install wget
brew install tree
brew install pkg-config
brew install libtool
brew install cmake
brew install autoconf
brew install automake
brew install mosh
brew install markdown
brew install pidof # pidof
brew install proctools # pkill, pgrep, pfind
brew install rmtrash # `rmtrash` moves file to Trash
brew install reattach-to-user-namespace # http://yuzuemon.hatenablog.com/entry/20120222/1329841466 # http://qiita.com/yuku_t/items/bea95b1bc6e6ca8a495b
brew install rbenv ruby-build
brew install readline
brew install ghq
brew install peco
# brew install coreutils --default-names # http://takuya-1st.hatenablog.jp/entry/20111230/1325272152
# brew install imagemagick
# brew install packer
brew install brew-cask

# .dmg with homebrew-cask
brew cask install google-chrome
# brew cask install firefox
# brew cask install vivaldi
brew cask install evernote
brew cask install dropbox
# brew cask install skype
brew cask install iterm2
# brew cask install limechat
# brew cask install sublime-text
# brew cask install marked2
# brew cask install xquartz
# brew cask install wireshark
# brew cask install kobito
brew cask install virtualbox
brew cask install vagrant
# brew cask install karabiner
# brew cask install echofon # mycask
# brew cask install cot-editor # mycask
# brew cask install macvim-kaoriya # mycask
# brew cask install gyazo # mycask
brew install neovim

# Remove outdated versions
brew cleanup
