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

# remove rprompt after executing a command
setopt transient_rprompt

# Disable Ctrl-d logout
set -o ignoreeof

# Disable autocorrect
#unsetopt correct_all

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
xterm)
  export TERM=xterm-256color
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
  mycmd=(${(s: :)${1}})
  echo -ne "\ek$(hostname|awk 'BEGIN{FS="."}{print $1}'):$mycmd[1]\e\\"
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
  echo -ne "\ek$(hostname|awk 'BEGIN{FS="."}{print $1}'):idle\e\\"
}
LANG=en_US.UTF-8 vcs_info
export LC_CTYPE=en_US.UTF-8
export SVN_EDITOR=/bin/vi
PROMPT="%{$fg_bold[red]%}🍣  %{$reset_color%}%m%% "
RPROMPT=' %~%1(v|%F{green}%1v%f|)'
export PAGER=lv

[[ $EMACS = t ]] && unsetopt zle

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
alias grep='grep -E --color=tty'
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
alias ctags="ctags -f .tags -R ."
if which ack > /dev/null 2>&1; then; else; alias ack="find * -type f | xargs grep"; fi
alias hub=$HOME/.dotfiles/.bin/hub

# noautocorrect
alias grep="nocorrect grep"

#### export ####
export SSL_CERT_FILE=/usr/local/etc/openssl/certs/cert.pem
export PATH=/usr/java/latest/bin:$PATH
export PATH=/usr/java/ant/bin:$PATH
export PATH=/usr/sbin:$PATH
export PATH=/usr/local/sbin:$PATH
export PATH=/usr/local/bin:$PATH
export PATH=$HOME/bin:$HOME/bin/local:$HOME/gitrepos/bin:$PATH
export PATH="/usr/local/heroku/bin:$PATH" ### Added by the Heroku Toolbelt
export JAVA_HOME=/usr/java/latest
export ANT_HOME=/usr/java/ant
export EDITOR=/usr/bin/vim
[[ -d ~/.rbenv/bin ]] && export PATH="$HOME/.rbenv/bin:$PATH"
if which rbenv > /dev/null 2>&1; then eval "$(rbenv init - zsh)"; fi
[[ -f "$HOME/perl5/perlbrew/etc/bashrc" ]] && source "$HOME/perl5/perlbrew/etc/bashrc"
[[ -d "$HOME/.nodebrew/current/bin" ]] && export PATH=$HOME/.nodebrew/current/bin:$PATH
[[ -d "$HOME/.pyenv/bin" ]] && export PATH="$HOME/.pyenv/bin:$PATH" && eval "$(pyenv init -)"

# load OS dependent zshrc
# .zshrc_darwin
# .zshrc_linux
[ -f "$HOME/.zshrc_$uname" ] && source "$HOME/.zshrc_$uname"
[ -f "$HOME/.zshrc_local" ] && source "$HOME/.zshrc_local"
# go
if [ "$uname" = "darwin" ]; then
  # brew install go
  export GOROOT=/usr/local/opt/go/libexec
else
  export GOROOT=/usr/local/go
fi
export PATH=$GOROOT/bin:$PATH
export GOPATH=$HOME
export PATH=$GOPATH/bin:$PATH
# goenv
export GOENVTARGET=$HOME/.goenvtarget
export PATH=$GOENVTARGET:$PATH
export GOENVGOROOT=$HOME/.goenvs
export GOENVTARGET=$HOME/bin
export GOENVHOME=$HOME/workspace

# auto tmux attach
if [ -n "$(which tmux)" ]; then
  if [ $SHLVL = 1 ]; then
    if [ $(( `ps aux | grep tmux | grep $USER | grep -v grep | wc -l` )) != 0 ]; then
      echo -n 'Attach tmux session? [Y/n]'
      read YN
      [[ $YN = '' ]] && YN=y
      [[ $YN = y ]] && tmux attach -d
    fi
  fi
fi
[ -f "$HOME/.zsh/function.zsh" ] && source "$HOME/.zsh/function.zsh"
