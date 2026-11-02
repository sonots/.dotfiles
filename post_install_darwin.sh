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
# Prefer homebrew zsh (Apple Silicon: /opt/homebrew, Intel: /usr/local),
# fall back to the system zsh.
if [ -x /opt/homebrew/bin/zsh ]; then
  zsh_path=/opt/homebrew/bin/zsh
elif [ -x /usr/local/bin/zsh ]; then
  zsh_path=/usr/local/bin/zsh
else
  zsh_path=/bin/zsh
fi
if ! grep -qx "$zsh_path" /etc/shells; then
  echo "$zsh_path" | sudo tee -a /etc/shells
fi
if [ "$SHELL" != "$zsh_path" ]; then
  chsh -s "$zsh_path"
fi
