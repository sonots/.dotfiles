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
else
  ln -s ~/.dotfiles/.tmux.conf.base ~/.tmux.conf
fi

vim -c ':NeoBundleInstall!' -c ':q!' -c ':q!'

# install go from pkg http://golang.org/dl/
# go get github.com/peco/peco/cmd/peco
# go get github.com/motemen/ghq

if [ $(uname) = "Darwin" ]; then
  # logout is required to reflect
  defaults write -g KeyRepeat -int 1
  defaults write -g KeyRepeat -int 10
fi

popd
