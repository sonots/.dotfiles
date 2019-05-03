export LANG=ja_JP.UTF-8
uname=`uname | tr A-Z a-z`

# oh-my-zsh
if [ -f $HOME/.oh-my-zsh -o -L $HOME/.oh-my-zsh ]; then
  ZSH=$HOME/.oh-my-zsh
  plugins=(git osx ruby gem)
  export DISABLE_AUTO_UPDATE="true"
  export DISABLE_UPDATE_PROMPT="true"
  source $ZSH/oh-my-zsh.sh
fi
unalias d
unalias gb # conflict with golang build tool

# turns on interactive comments; comments begin with a #.
setopt interactivecomments

# remove rprompt after executing a command
setopt transient_rprompt

# Disable Ctrl-d logout
set -o ignoreeof

# Disable autocorrect
unsetopt correct_all

# color
autoload colors
colors

# autocorrect
setopt correct
setopt list_packed
setopt noautoremoveslash
setopt noautoremoveslash
autoload predict-on
#predict-on

# keybind emacs
bindkey -e

#string binded to ^P/^N
autoload history-search-end
zle -N history-beginning-search-backward-end history-search-end
zle -N history-beginning-search-forward-end history-search-end
bindkey "^p" history-beginning-search-backward-end
bindkey "^n" history-beginning-search-forward-end
bindkey "\\ep" history-beginning-search-backward-end
bindkey "\\en" history-beginning-search-forward-end

# history
HISTFILE=~/.zsh_history
HISTSIZE=10000
SAVEHIST=10000
setopt hist_ignore_dups # ignore duplication command history list
setopt share_history # share command history data

# completion
fpath=(~/.zsh/functions/Completion ${fpath})
autoload -U compinit
compinit

autoload zed # zsh editor
setopt complete_aliases # aliased ls needs if file/dir completions work
hosts=( ${(@)${${(M)${(s:# :)${(zj:# :)${(Lf)"$([[ -f ~/.ssh/config ]] && < ~/.ssh/config)"}%%\#*}}##host(|name) *}#host(|name) }/\*} )
zstyle ':completion:*:hosts' hosts $hosts

# terminal
unset LSCOLORS
case "${TERM}" in
dumb*|emacs*)
  PROMPT="[%n@%m %~]$ "
  PROMPT2="%_%% "
  SPROMPT="%r is correct? [n,y,a,e]: "
  ;;
screen)
  export TERM=xterm-256color
  ;;
xterm)
  export TERM=xterm-256color # for vim lightline
  ;;
kterm)
  export TERM=kterm-color
  # set BackSpace control character
  stty erase
  ;;
cons25)
  unset LANG
  export LSCOLORS=ExFxCxdxBxegedabagacad
#  export LS_COLORS='di=01;34:ln=01;35:so=01;32:ex=01;31:bd=46;34:cd=43;34:su=41;30:sg=46;30:tw=42;30:ow=43;30'
  export LS_COLORS='di=01;34:ln=01;35:so=01;32:ex=01;31:bd=46;34:cd=43;34:su=41;30:sg=46;30'
  zstyle ':completion:*' list-colors \
      'di=;34;1' 'ln=;35;1' 'so=;32;1' 'ex=31;1' 'bd=46;34' 'cd=43;34'
  ;;
kterm*|xterm*)
  precmd() {
    echo -ne "\033]0;${USER}@${HOST%%.*}:${PWD}\007"
  }
  export LSCOLORS=exfxcxdxbxegedabagacad
  #export LS_COLORS='di=34:ln=35:so=32:pi=33:ex=31:bd=46;34:cd=43;34:su=41;30:sg=46;30:tw=42;30:ow=43;30'
  export LS_COLORS='di=34:ln=35:so=32:pi=33:ex=31:bd=46;34:cd=43;34:su=41;30:sg=46;30'
  zstyle ':completion:*' list-colors \
    'di=34' 'ln=35' 'so=32' 'ex=31' 'bd=46;34' 'cd=43;34'
  ;;
esac

setopt NO_BEEP
setopt RC_EXPAND_PARAM

export LANG="en_US.UTF-8"
export LANGUAGE="en_US.UTF-8"
export LC_CTYPE="en_US.UTF-8"

## keep background processes at full speed
#setopt NOBGNICE
## restart running processes on exit
#setopt HUP

## history
#setopt APPEND_HISTORY
## for sharing history between zsh processes
#setopt INC_APPEND_HISTORY
#setopt SHARE_HISTORY

## never ever beep ever
#setopt NO_BEEP

## automatically decide when to page a list of completions
#LISTMAX=0

## disable mail checking
#MAILCHECK=0

# autoload -U colors
#colors

# for screen, tmux, iterm2
preexec() {
  # mycmd=(${(s: :)${1}})
  # echo -ne "\ek$(hostname|awk 'BEGIN{FS="."}{print $1}'):$mycmd[1]\e\\"
  echo -ne "\ek${PWD:t}\e\\"
}
# vcs_info
autoload -Uz vcs_info
zstyle ':vcs_info:*' formats '(%b)'
zstyle ':vcs_info:*' actionformats '(%b|%a)'
precmd () {
  # vcs_info
  psvar=()
  LANG=en_US.UTF-8 vcs_info
  [[ -n "$vcs_info_msg_0_" ]] && psvar[1]="$vcs_info_msg_0_"
  # for screen, tmux, itemr2
  # echo -ne "\ek$(hostname|awk 'BEGIN{FS="."}{print $1}'):idle\e\\"
  echo -ne "\ek${PWD:t}\e\\"
}
LANG=en_US.UTF-8 vcs_info
export LC_CTYPE=en_US.UTF-8
export SVN_EDITOR=/bin/vi
function check-shell-command {
  if [ $? -eq 0 ]; then
    host="%{$fg_bold[green]%}%m%{$reset_color%}"
  else
    host="%{$fg_bold[red]%}%m%{$reset_color%}"
  fi
  echo -e "${host}"
}
function prompt() {
  echo -e "$(check-shell-command)$ "
}
PROMPT='$(prompt)'
RPROMPT=' %~%1(v|%F{green}%1v%f|)'
export PAGER="less -c"

[[ $EMACS = t ]] && unsetopt zle

if which tmux > /dev/null; then
  show-current-dir-as-window-name() {
      tmux set-window-option window-status-format " #I ${PWD:t} " > /dev/null
      tmux set-window-option window-status-current-format " #I ${PWD:t} " > /dev/null
  }
  show-current-dir-as-window-name
  add-zsh-hook chpwd show-current-dir-as-window-name
fi

#### plugins ####
# z - jump around https://github.com/rupa/z
source ~/.zsh/z/z.sh
compctl -U -K _z_zsh_tab_completion z # enable tab completion for z, not only for _z

# zsh incremental completion. too slow... let me disabled
#source ~/.zsh/incr*.zsh

#### alias ####
#by cd -[tab]
setopt auto_pushd
alias ll='ls -l'
alias la='ls -a'
alias lla='ls -la'
alias lld='ls -ld'
alias du="du -h"
alias df="df -h"
alias du="du -h"
alias df="df -h"
alias su="su -l"
alias where="command -v"
alias j="jobs -l"

alias dstat-full='dstat -Tclmdrn'
alias dstat-mem='dstat -Tclm'
alias dstat-cpu='dstat -Tclr'
alias dstat-net='dstat -Tclnd'
alias dstat-disk='dstat -Tcldr'
alias jj="ruby -rjson -e 'jj JSON[ARGF.read]'"
alias fs='nocorrect be foreman start'
alias gru='git remote update'
alias gupull='git pull --rebase upstream `git current-branch`'
alias gupush='git push upstream `git current-branch`'
alias gfpull='git pull --rebase fork `git current-branch`'
alias gfpush='git push fork `git current-branch`'
alias gsts='git stash save'
alias gstp='git stash pop'
alias ctags="ctags -f .tags -R ."
alias gotags="gotags -f .tags -R ."
if which ack > /dev/null 2>&1; then; else; alias ack="find . \( -name 'vendor' -o -name '.git' -o -name 'log' -o -name '.tags' \) -prune -o -type f -print0 | xargs -0 grep -n"; fi

# noautocorrect
unset GREP_OPTIONS
alias grep='grep -E --color=tty'
alias grep="nocorrect grep"

#### export ####
# export SSL_CERT_FILE=/usr/local/etc/openssl/certs/cert.pem
export PATH=/usr/java/latest/bin:$PATH
export PATH=/usr/java/ant/bin:$PATH
export PATH=/usr/sbin:$PATH
export PATH=/usr/local/sbin:$PATH
export PATH=/usr/local/bin:$PATH
export PATH=$HOME/bin:$HOME/local/bin:$HOME/gitrepos/bin:$HOME/.dotfiles/.bin:$PATH
export PATH="/usr/local/heroku/bin:$PATH" ### Added by the Heroku Toolbelt
export PATH=$HOME/.local/bin:$PATH
export LD_LIBRARY_PATH=$HOME/local/lib:$LD_LIBRARY_PATH
export EDITOR=/usr/bin/vim
if [ -x /usr/libexec/java_home ]; then
  if /usr/java/latest > /dev/null 2>&1; then
    export JAVA_HOME=$(/usr/libexec/java_home)
  fi
elif [ -x /usr/java/latest/bin/java ]; then
  export JAVA_HOME=/usr/java/latest
fi
[[ -d /usr/java/ant ]] && export ANT_HOME=/usr/java/ant
[[ -d ~/.rbenv/bin ]] && export PATH="$HOME/.rbenv/bin:$PATH"
if which rbenv > /dev/null 2>&1; then eval "$(rbenv init - zsh)"; fi
[[ -f "$HOME/perl5/perlbrew/etc/bashrc" ]] && source "$HOME/perl5/perlbrew/etc/bashrc"
[[ -d "$HOME/.nodebrew/current/bin" ]] && export PATH=$HOME/.nodebrew/current/bin:$PATH
[[ -d "$HOME/.pyenv/bin" ]] && export PATH="$HOME/.pyenv/bin:$PATH" && eval "$(pyenv init -)"
[[ -d "$HOME/.plenv/bin" ]] && export PATH="$HOME/.plenv/bin:$PATH" && eval "$(plenv init - zsh)"
[[ -d "$HOME/.cargo/bin" ]] && export PATH="$HOME/.cargo/bin:$PATH"
[[ -d "/usr/local/opt/mysql@5.6/bin" ]] && export PATH="/usr/local/opt/mysql@5.6/bin:$PATH"
[[ -d "$HOME/google-cloud-sdk/bin" ]] && export PATH="$HOME/google-cloud-sdk/bin:$PATH"
[[ -d "$HOME/miniconda3/bin" ]] && export PATH="$HOME/miniconda3/bin:$PATH"

# go
if [ "$uname" = "darwin" ]; then
  # brew install go
  export GOROOT=/usr/local/opt/go/libexec
elif [ -d "$HOME/local/go" ]; then
  export GOROOT="$HOME/local/go"
else
  export GOROOT=/usr/local/go
fi
export PATH=$GOROOT/bin:$PATH
export GOPATH=$HOME/go
export PATH=$GOPATH/bin:$PATH
# goenv
export GOENVTARGET=$HOME/.goenvtarget
export PATH=$GOENVTARGET:$PATH
export GOENVGOROOT=$HOME/.goenvs
export GOENVTARGET=$HOME/bin
export GOENVHOME=$HOME/workspace

# llvm and cmake
[[ -d $HOME/opt/llvm/bin ]] && export PATH=$HOME/opt/llvm/bin:$PATH
[[ -d $HOME/opt/cmake/bin ]] && export PATH=$HOME/opt/cmake/bin:$PATH

[ -f "$HOME/.zsh/function.zsh" ] && source "$HOME/.zsh/function.zsh"

# load OS dependent zshrc such as .zshrc.darwn, .zshrc.linux
[ -f "$HOME/.zshrc.$uname" ] && source "$HOME/.zshrc.$uname"
[ -f "$HOME/.zshrc.local" ] && source "$HOME/.zshrc.local"

# keep SSH_AUTH_SOCK on tmux
agent="$HOME/.ssh/agent"
if [ -S "$SSH_AUTH_SOCK" ]; then
  case $SSH_AUTH_SOCK in
  /tmp/*/agent.[0-9]*)
    ln -snf "$SSH_AUTH_SOCK" $agent && export SSH_AUTH_SOCK=$agent
  esac
elif [ -S $agent ]; then
  export SSH_AUTH_SOCK=$agent
fi

# auto tmux attach
if [ -n "$(which tmux)" ]; then
  if [ $SHLVL = 1 ]; then
    if [ -n "$SSH_TTY" ]; then
      if [ $(( `ps aux | grep tmux | grep $USER | grep -v grep | wc -l` )) != 0 ]; then
        echo -n 'Attach tmux session? [Y/n]'
        read YN
        [[ $YN = '' ]] && YN=y
        [[ $YN = 'y' ]] || [[ $YN = 'Y' ]] && tmux attach -d
      fi
    fi
  fi
fi

# for chainer
if [ -d /usr/local/cuda ]; then
  export CUDA_PATH="/usr/local/cuda"
  export CPATH="$CUDA_PATH/include:$CPATH"
  export LD_LIBRARY_PATH="$CUDA_PATH/lib64:$CUDA_PATH/lib:$LD_LIBRARY_PATH"
  export PATH="$CUDA_PATH/bin:$PATH"
  export LIBRARY_PATH="$CUDA_PATH/lib64:$CUDA_PATH/lib:$LIBRARY_PATH"
fi
if [ -d "$HOME/.cudnn" ]; then
  export LD_LIBRARY_PATH="$HOME/.cudnn/active/cuda/lib64:/usr/lib/x86_64-linux-gnu:$LD_LIBRARY_PATH"
  export LIBRARY_PATH="$HOME/.cudnn/active/cuda/lib64:/usr/lib/x86_64-linux-gnu:$LIBRARY_PATH"
  export CPATH="$HOME/.cudnn/active/cuda/include:$CPATH"
  export LDFLAGS="-L$HOME/.cudnn/active/cuda/lib64 $LDFLAGS"
  export CFLAGS="-I$HOME/.cudnn/active/cuda/include $CFLAGS"
  export CUDNN_ROOT_DIR="$HOME/.cudnn/active/cuda"
fi
if [ -d "$HOME/nccl" ]; then
  export LD_LIBRARY_PATH="$HOME/nccl/build/lib:$LD_LIBRARY_PATH"
  export LDFLAGS="-L$HOME/nccl/build/lib $LDFLAGS"
  export CFLAGS="-I$HOME/nccl/build/include $CFLAGS"
fi

# ccache
if [ -d "$HOME/opt/ccache" ]; then
  export PATH="$HOME/opt/ccache/bin:$PATH"
  ln -sf "$HOME/opt/ccache/bin/ccache" "$HOME/opt/ccache/bin/gcc"
  ln -sf "$HOME/opt/ccache/bin/ccache" "$HOME/opt/ccache/bin/g++"
  ln -sf "$HOME/opt/ccache/bin/ccache" "$HOME/opt/ccache/bin/nvcc"
  export NVCC="ccache nvcc"
fi

# miniconda
if [ -d "$HOME/miniconda3/envs/myenv" ]; then
  CONDA_PREFIX="$HOME/miniconda3/envs/myenv"
  # source activate myenv
  export LD_LIBRARY_PATH="$CONDA_PREFIX/lib:$LD_LIBRARY_PATH"
  export LIBRARY_PATH="$CONDA_PREFIX/lib:$LIBRARY_PATH"
  export LDFLAGS="-L$CONDA_PREFIX/lib $LDFLAGS"
  export CPATH="$CONDA_PREFIX/include:$CPATH"
  export CFLAGS="-I$CONDA_PREFIX/include $CFLAGS"
fi

if [ -d "$HOME/local/include" ]; then
  export CPATH="$HOME/local/include:$CPATH"
  export CFLAGS="-I$HOME/local/include $CFLAGS"
fi
if [ -d "$HOME/local/lib" ]; then
  export LD_LIBRARY_PATH="$HOME/local/lib:$LD_LIBRARY_PATH"
  export LIBRARY_PATH="$HOME/local/lib:$LIBRARY_PATH"
  export LDFLAGS="-L$HOME/local/lib $LDFLAGS"
fi

alias onnxdump="python -c 'import onnx; import sys; print(onnx.load(sys.argv[1]))'"

# gcloud
# brew cask install google-cloud-sdk
if [ -f /usr/local/Caskroom/google-cloud-sdk/latest/google-cloud-sdk/completion.zsh.inc ]; then
  . /usr/local/Caskroom/google-cloud-sdk/latest/google-cloud-sdk/completion.zsh.inc
fi

# https://qiita.com/sonots/items/906798c408132e26b41c
function kubectl-config() {
  cluster=$(kubectl config get-clusters | peco)
  kubectl config use-context "${cluster}"
}
function gcloud-config() {
  line=$(gcloud config configurations list | peco)
  project=$(echo "${line}" | awk '{print $1}')
  gcloud config configurations activate "${project}"
  cluster=$(kubectl config get-clusters | grep "${project}")
  if [ -n "${cluster}" ]; then; kubectl config use-context "${cluster}"; fi
}
function gcloud-config-create() {
  name="$1" # alias
  if [ -z "$2" ]; then
    project="$name"
  else
    project="$2"
  fi
  echo "gcloud config configurations activate default"
  gcloud config configurations activate default
  echo "gcloud config configurations delete \"$name\" || true"
  gcloud config configurations delete "$name" || true
  echo "gcloud config configurations create \"$name\""
  gcloud config configurations create "$name"
  echo "gcloud config set project \"$project\""
  gcloud config set project "$project"
  echo "gcloud config set account \"naotoshi.seo@zozo.com\""
  gcloud config set account "naotoshi.seo@zozo.com"
}
# Get real project name
function gcloud-alias() {
  name="$1" # alias
  gcloud config configurations list | grep "^${name}" | head -1 | awk '{print $4}'
}
function gcloud-current() {
  cat $HOME/.config/gcloud/active_config
}
