if [ $(uname) = "Darwin" ]; then
  tmux set-option -g default-command "reattach-to-user-namespace -l zsh"
fi
