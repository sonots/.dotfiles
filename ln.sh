#!/bin/sh
[ -d .zsh/zaw ] || git clone git://github.com/zsh-users/zaw .zsh/zaw
git submodule init
git submodule update
for i in `ls -a`
do
  [ $i = "." ] && continue
  [ $i = ".." ] && continue
  [ $i = ".git" ] && continue
  [ $i = "ln.sh" ] && continue
  ln -s ~/.dotfiles/$i ~/
done
