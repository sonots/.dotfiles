#!/bin/bash

# Homebrew はインストールプランの確認プロンプト (ask mode) がデフォルトに
# なったため、スクリプト実行では無効化する ("Invalid input. Please press 'y'
# to proceed" で止まる対策)
export HOMEBREW_NO_ASK=1
# Homebrew 自体のインストーラも非対話にする
export NONINTERACTIVE=1

. ~/.dotfiles/_run.sh

which brew || /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh)"
run brew update

# Update already-installed formula (takes too much time, I will do it manually later)
# brew upgrade

# Packages

run brew install vim
run brew install zsh
run brew install git
# brew install gist
run brew install tig
run brew install tmux
run brew install ctags
run brew install nkf
# brew install lv
# brew install htop
run brew install wget
run brew install tree
run brew install pkg-config
run brew install libtool
run brew install cmake
run brew install autoconf
run brew install automake
run brew install pstree
# brew install pidof # pidof
# brew install rmtrash # `rmtrash` moves file to Trash
run brew install rbenv ruby-build
run brew install readline
run brew install ghq
run brew install peco
# brew install fzf # Either of peco or fzf should be ehough
run brew install ag
# brew install ripgrep # Either of ag or rg (ripgrep) should be enough
run brew install direnv
run brew install jq
run brew install python-yq
run brew install coreutils # gdate, gsed
# brew install coreutils --default-names # http://takuya-1st.hatenablog.jp/entry/20111230/1325272152
# brew install imagemagick
# brew install packer
# kubernetes
# brew install kubectl
# brew install krew
# brew install kustomize
# brew install k9s
# brew install --cask lens
run brew install golang
# brew install jenv # java
# brew install tfenv # terraform

# AI
run brew install --cask claude # Claude Desktop, not the CLI
run brew install --cask claude-code@latest # the `claude-code` cask pins an older version
run brew install --cask codex
run brew install --cask chatgpt
run brew install --cask grok-bot
run brew install --cask cursor
run brew install --cask antigravity-cli # installs as `agy`
run brew install --cask google-gemini # the `gemini` cask is MacPaw's disk cleaner; needs arm64 and macOS 15+

# Install .dmg by homebrew-cask
run brew install --cask google-chrome
# brew install --cask firefox
run brew install --cask  iterm2
# brew install --cask  xquartz
# brew install --cask  wireshark
# brew install --cask  virtualbox
# brew install --cask  vagrant
run brew install --cask visual-studio-code
# brew install --cask skitch
# brew install --cask discord
run brew install --cask slack
run brew install --cask kindle

# Mac App Store (Homebrew cask に無いもの)
# App Store にサインインしていて、購入履歴に入っているものしか入らない
run brew install mas
run mas install 1407015686 # Paste Plain Text

# Remove outdated versions
run brew cleanup
