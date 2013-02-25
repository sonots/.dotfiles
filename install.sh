#!/bin/sh

[[ -e ~/.dotfiles ]] || git clone git@github.com:sonots/.dotfiles.git ~/.dotfiles
pushd ~/.dotfiles

git submodule init
git submodule update

if [ `uname` = "Darwin" ]; then
  pushd ~/.dotfiles/.vim/bundle/vimproc
  make -f make_mac.mak
  popd

  ln -s ~/.dotfiles/.tmux.conf.mac ~/.tmux.conf
fi

for i in `ls -a`
do
  [ $i = "." ] && continue
  [ $i = ".." ] && continue
  [ $i = ".git" ] && continue
  [ $i = "README.md" ] && continue
  ln -s ~/.dotfiles/$i ~/
done
vim -c ':BundleInstall!' -c ':q!' -c ':q!'

popd
