#!/bin/bash

[[ -e ~/.dotfiles ]] || git clone https://github.com/sonots/.dotfiles.git ~/.dotfiles
pushd ~/.dotfiles

git submodule init
git submodule update

for i in `ls -a`
do
  [ $i = "." ] && continue
  [ $i = ".." ] && continue
  [ $i = ".git" ] && continue
  [ $i = "README.md" ] && continue
  [ $i = "install.sh" ] && continue
  [ $i = "Brewfile.sh" ] && continue
  ln -s ~/.dotfiles/$i ~/
done

if [ $(uname) = "Darwin" ]; then
  ./Brewfile.sh
  brew tap sanemat/font
  brew install ricty
  cp -f /usr/local/Cellar/ricty/3.2.2/share/fonts/Ricty*.ttf ~/Library/Fonts/
  fc-cache -vf
  ln -s ~/.dotfiles/.tmux.conf.darwin ~/.tmux.conf
  # curl https://sdk.cloud.google.com | bash
  # curl "https://awscli.amazonaws.com/AWSCLIV2.pkg" -o "/tmp/AWSCLIV2.pkg"
  # sudo installer -pkg /tmp/AWSCLIV2.pkg -target / # /usr/local/bin/aws
else
  apt install -y git
  apt install -y vim
  apt install -y zsh
  apt install -y tmux
  apt install -y silversearcher-ag
  ln -s ~/.dotfiles/.tmux.conf.linux ~/.tmux.conf
fi

vim -c ':NeoBundleInstall!' -c ':q!' -c ':q!'
# Require recent golang, GOROOT=/usr/local/go and GOPATH=$HOME/go
# vim -c ':GoInstallBinaries' -c ':q!' -c ':q!'

# install go from pkg http://golang.org/dl/
# go get github.com/peco/peco/cmd/peco
# go get github.com/motemen/ghq

if [ $(uname) = "Darwin" ]; then
  # logout is required to reflect
  defaults write -g KeyRepeat -int 1
  defaults write -g InitialKeyRepeat -int 15
  # Show hidden files on Finder
  defaults write com.apple.finder AppleShowAllFiles TRUE
fi

# krew
(
  set -x; cd "$(mktemp -d)" &&
  curl -fsSLO "https://github.com/kubernetes-sigs/krew/releases/latest/download/krew.{tar.gz,yaml}" &&
  tar zxvf krew.tar.gz &&
  KREW=./krew-"$(uname | tr '[:upper:]' '[:lower:]')_amd64" &&
  "$KREW" install --manifest=krew.yaml --archive=krew.tar.gz &&
  "$KREW" update
)

popd
