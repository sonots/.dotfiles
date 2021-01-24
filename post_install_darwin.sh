#!/bin/bash

# logout is required to reflect
defaults write -g KeyRepeat -int 1
defaults write -g InitialKeyRepeat -int 15
# Show hidden files on Finder
defaults write com.apple.finder AppleShowAllFiles TRUE

# .ssh/config
if ! grep -q '^# .dotfiles/install.sh' $HOME/.ssh/config; then
  mkdir -p $HOME/.ssh
  cat <<EOF >> $HOME/.ssh/config
# .dotfiles/install.sh
Host *
  # UseKeychain yes
  AddKeysToAgent yes
  ForwardAgent yes
  ServerAliveInterval 15
  ServerAliveCountMax 10

# SSH over Session Manager
host i-* mi-*
  ProxyCommand sh -c "aws ssm start-session --target %h --document-name AWS-StartSSHSession --parameters 'portNumber=%p'"
EOF
 chmod 700 $HOME/.ssh
 chmod 600 $HOME/.ssh/config
fi

# change default shell to zsh
if ! grep -q /usr/local/bin/zsh /etc/shells; then
  echo /usr/local/bin/zsh | sudo tee -a /etc/shells
fi
chsh -s /usr/local/bin/zsh
