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

# Install language servers (same as :LspInstallServer of mattn/vim-lsp-settings,
# but run the installer scripts directly so it works non-interactively).
# :LspInstallServer installs are async (term_start), so headless vim can't wait for them.
# Note: ruby (solargraph / ruby-lsp) is excluded: native gems do not build on ruby 4.x yet.
[ -n "$GOROOT" ] && [ ! -d "$GOROOT" ] && unset GOROOT  # stale GOROOT breaks go install
lsp_installer_dir=~/.dotfiles/.vim/bundle/vim-lsp-settings/installer
lsp_servers_dir=${XDG_DATA_HOME:-~/.local/share}/vim-lsp-settings/servers
for server in bash-language-server gopls pyright-langserver terraform-ls typescript-language-server vim-language-server; do
  if [ ! -d "$lsp_servers_dir/$server" ]; then
    echo "Installing language server: $server"
    mkdir -p "$lsp_servers_dir/$server"
    (cd "$lsp_servers_dir/$server" && sh "$lsp_installer_dir/install-$server.sh") || echo "WARN: failed to install $server"
  fi
done

./"post_install_${uname}.sh"

popd
