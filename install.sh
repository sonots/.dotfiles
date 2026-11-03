#!/bin/bash

uname=`uname | tr A-Z a-z`

# 失敗しても止めずに最後まで走らせ、何が失敗したかを最後にまとめて出す。
# 独立した手順が多く1つコケても残りは進めたいので set -e は使わない。
failed=()
run() {
  "$@" || failed+=("$*")
}

# Command Line Tools が無いと git を呼ぶたびに GUI のインストールダイアログが
# 出てしまうので、先にインストールして完了を待つ
if [ "${uname}" = "darwin" ] && ! xcode-select -p >/dev/null 2>&1; then
  xcode-select --install
  echo "Waiting for Command Line Tools installation to complete..."
  until xcode-select -p >/dev/null 2>&1; do
    sleep 10
  done
fi

[[ -e ~/.dotfiles ]] || git clone https://github.com/sonots/.dotfiles.git ~/.dotfiles
pushd ~/.dotfiles

run git submodule init
run git submodule update

for i in `ls -a`
do
  [ $i = "." ] && continue
  [ $i = ".." ] && continue
  [ $i = ".git" ] && continue
  [ $i = "README.md" ] && continue
  [ $i = "install.sh" ] && continue
  [ $i = "Brewfile.sh" ] && continue
  [ $i = "iterm2" ] && continue # iTerm2 が読む設定。~ には置かない
  # -f で張り直し、-n でシンボリックリンクのディレクトリを辿らせない（再実行時に
  # リンク先の中へ入れ子のリンクを作らないため）
  run ln -sfn ~/.dotfiles/$i ~/
done

if [ "${uname}" = "darwin" ]; then
  run ./Brewfile.sh
  run brew tap sanemat/font
  run brew install ricty
  run cp -f /usr/local/Cellar/ricty/3.2.2/share/fonts/Ricty*.ttf ~/Library/Fonts/
  run fc-cache -vf
  run ln -sfn ~/.dotfiles/.tmux.conf.darwin ~/.tmux.conf
  # curl https://sdk.cloud.google.com | bash
  # curl "https://awscli.amazonaws.com/AWSCLIV2.pkg" -o "/tmp/AWSCLIV2.pkg"
  # sudo installer -pkg /tmp/AWSCLIV2.pkg -target / # /usr/local/bin/aws
else
  run apt install -y git
  run apt install -y vim
  run apt install -y zsh
  run apt install -y tmux
  run apt install -y silversearcher-ag
  run ln -sfn ~/.dotfiles/.tmux.conf.linux ~/.tmux.conf
fi

run vim -c ':NeoBundleInstall!' -c ':q!' -c ':q!'
run vim -c ':PluginInstall!' -c ':q!' -c ':q!'
# Require recent golang, GOROOT=/usr/local/go and GOPATH=$HOME/go
run vim -c ':GoInstallBinaries' -c ':q!' -c ':q!'

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
    (cd "$lsp_servers_dir/$server" && sh "$lsp_installer_dir/install-$server.sh") || failed+=("install-$server.sh")
  fi
done

run ./"post_install_${uname}.sh"

popd

if [ ${#failed[@]} -gt 0 ]; then
  echo >&2
  echo "以下が失敗しました:" >&2
  printf '  %s\n' "${failed[@]}" >&2
  exit 1
fi
