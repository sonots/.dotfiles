#!/bin/sh

[[ -e ~/.dotfiles ]] || git clone git@github.com:sonots/.dotfiles.git ~/.dotfiles
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
  ln -s ~/.dotfiles/$i ~/
done

if [ `uname` = "Darwin" ]; then
  brew bundle
fi

vim -c ':NeoBundleInstall!' -c ':q!' -c ':q!'

popd
