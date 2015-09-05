#!/bin/sh

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
  [ $i = "Brewfile" ] && continue
  ln -s ~/.dotfiles/$i ~/
done

if [ `uname` = "Darwin" ]; then
  brew bundle
  brew tap sanemat/font
  brew install ricty
  cp -f /usr/local/Cellar/ricty/3.2.2/share/fonts/Ricty*.ttf ~/Library/Fonts/
  fc-cache -vf
  ln -sf ~/.tmux.conf_darwin ~/.tmux.conf
else
  ln -sf ~/.tmux.conf_common ~/.tmux.conf
fi

vim -c ':NeoBundleInstall!' -c ':q!' -c ':q!'

# install go from pkg http://golang.org/dl/
# go get github.com/peco/peco/cmd/peco
# go get github.com/motemen/ghq

popd
