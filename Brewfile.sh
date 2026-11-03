#!/bin/bash

# Homebrew はインストールプランの確認プロンプト (ask mode) がデフォルトに
# なったため、スクリプト実行では無効化する ("Invalid input. Please press 'y'
# to proceed" で止まる対策)
export HOMEBREW_NO_ASK=1
# Homebrew 自体のインストーラも非対話にする
export NONINTERACTIVE=1

which brew || /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh)"
brew update

# Update already-installed formula (takes too much time, I will do it manually later)
# brew upgrade

# Packages

brew install vim
brew install zsh
brew install git
# brew install gist
brew install tig
brew install tmux
brew install ctags
brew install nkf
# brew install lv
# brew install htop
brew install wget
brew install tree
brew install pkg-config
brew install libtool
brew install cmake
brew install autoconf
brew install automake
brew install pstree
# brew install pidof # pidof
# brew install rmtrash # `rmtrash` moves file to Trash
brew install rbenv ruby-build
brew install readline
brew install ghq
brew install peco
# brew install fzf # Either of peco or fzf should be ehough
brew install ag
# brew install ripgrep # Either of ag or rg (ripgrep) should be enough
brew install direnv
brew install jq
brew install python-yq
brew install coreutils # gdate, gsed
# brew install coreutils --default-names # http://takuya-1st.hatenablog.jp/entry/20111230/1325272152
# brew install imagemagick
# brew install packer
# kubernetes
# brew install kubectl
# brew install krew
# brew install kustomize
# brew install k9s
# brew install --cask lens
brew install golang
# brew install jenv # java
# brew install tfenv # terraform

# AI
brew install --cask claude # Claude Desktop, not the CLI
brew install --cask claude-code@latest # the `claude-code` cask pins an older version
brew install --cask codex
brew install --cask chatgpt
brew install --cask grok-bot
brew install --cask cursor
brew install --cask antigravity-cli # installs as `agy`
brew install --cask google-gemini # the `gemini` cask is MacPaw's disk cleaner; needs arm64 and macOS 15+

# Install .dmg by homebrew-cask
brew install --cask google-chrome
# brew install --cask firefox
brew install --cask  iterm2
# brew install --cask  xquartz
# brew install --cask  wireshark
# brew install --cask  virtualbox
# brew install --cask  vagrant
brew install --cask visual-studio-code
# brew install --cask skitch
# brew install --cask discord
brew install --cask slack
brew install --cask kindle

# Mac App Store (Homebrew cask に無いもの)
# App Store にサインインしていて、購入履歴に入っているものしか入らない
brew install mas
mas install 1407015686 # Paste Plain Text

# Remove outdated versions
brew cleanup
