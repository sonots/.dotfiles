#!/bin/bash

uname=`uname | tr A-Z a-z`

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

if [ "${uname}" = "darwin" ]; then
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
vim -c ':PluginInstall!' -c ':q!' -c ':q!'
# Require recent golang, GOROOT=/usr/local/go and GOPATH=$HOME/go
vim -c ':GoInstallBinaries' -c ':q!' -c ':q!'

./"post_install_${uname}.sh"

popd
