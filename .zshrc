export LANG=ja_JP.UTF-8
uname=`uname`

# oh-my-zsh
ZSH=$HOME/.oh-my-zsh
plugins=(git osx ruby gem)
source $ZSH/oh-my-zsh.sh

# color
autoload colors
colors

# prompt
case ${UID} in
  0)
    #PROMPT="[%n@%m]$ "
    #RPROMPT="%~"
    #PROMPT2="%_%% "
    #SPROMPT="%r is correct? [n,y,a,e]: "
    PROMPT="%B%{${fg[red]}%}%n@%m %/#%{${reset_color}%}%b "
    PROMPT2="%B%{${fg[red]}%}%_#%{${reset_color}%}%b "
    SPROMPT="%B%{${fg[red]}%}%r is correct? [n,y,a,e]:%{${reset_color}%}%b "
    ;;
  *)
    #PROMPT="%{${fg[cyan]}%}[%n@%m %~]%{${reset_color}%}$ "
    PROMPT="%{${fg[cyan]}%}[%n@%m]%{${reset_color}%}$ "
    RPROMPT="%{${fg[cyan]}%}%~%{${reset_color}%}"
    PROMPT2="%{${fg[cyan]}%}%_%%%{${reset_color}%} "
    SPROMPT="%{${fg[cyan]}%}%r is correct? [n,y,a,e]:%{${reset_color}%} "
    ;;
esac

# autocorrect
setopt correct
setopt list_packed
setopt noautoremoveslash
setopt noautoremoveslash
autoload predict-on
#predict-on

# plugin
if [ "$uname" != "Darwin" ]; then
  source ~/.zsh/zaw/zaw.zsh
  bindkey '^R' zaw-history
fi
#source ~/.zsh/incr*.zsh

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

autoload zed
setopt complete_aliases # aliased ls needs if file/dir completions work
hosts=( ${(@)${${(M)${(s:# :)${(zj:# :)${(Lf)"$([[ -f ~/.ssh/config ]] && < ~/.ssh/config)"}%%\#*}}##host(|name) *}#host(|name) }/\*} )
zstyle ':completion:*:hosts' hosts $hosts

##########################
# alias

case "`uname`" in
  Darwin) # OSがMacならば
    if [ -d /Applications/MacVim.app ]; then # MacVimが存在するならば
      export EDITOR=/Applications/MacVim.app/Contents/MacOS/Vim
      alias vim='/Applications/MacVim.app/Contents/MacOS/Vim'
      alias vi='vim'
    fi
    setopt auto_cd
    function chpwd(){ls -F -G}
    alias ls='ls -G'
    ;;

  *) # OSがMac以外
    setopt auto_cd
    function chpwd(){ls -F --color=tty}
    alias ls='ls --color=tty'
    ;; 
esac

#by cd -[tab]
setopt auto_pushd

alias ll='ls -l'
alias la='ls -a'
alias lla='ls -la'
alias lld='ls -ld'
alias sl=ls

alias du="du -h"
alias df="df -h"

alias du="du -h"
alias df="df -h"

alias su="su -l"

alias grep='grep -E --color=tty'
#alias top='top -d 1'
#alias xqbiff='xqbiff -mode=pop -pt 0 -na -sort=new'

alias ltime='/usr/bin/time --format="\n----\nr %e/u %U/s %S sec"'

alias where="command -v"
alias j="jobs -l"


# terminal
unset LSCOLORS
case "${TERM}" in
dumb*|emacs*)
  PROMPT="[%n@%m %~]$ "
  PROMPT2="%_%% "
  SPROMPT="%r is correct? [n,y,a,e]: "
  ;;

xterm)
  export TERM=xterm-color
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
esac

case "${TERM}" in
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
export SVN_EDITOR=/bin/vi
PROMPT="%{$fg_bold[red]%}➜ %{$reset_color%}%m%% "
RPROMPT=' %~%1(v|%F{green}%1v%f|)'

[[ $EMACS = t ]] && unsetopt zle

export PATH=/usr/java/latest/bin:$PATH
export PATH=/usr/java/ant/bin:$PATH
export PATH=/usr/sbin:$PATH
export PATH=/usr/local/sbin:$PATH
export PATH=/usr/local/bin:$PATH
export PATH=$HOME/bin:$PATH
export JAVA_HOME=/usr/java/latest
export ANT_HOME=/usr/java/ant
export EDITOR=/usr/bin/vim
alias dstat-full='dstat -Tclmdrn'
alias dstat-mem='dstat -Tclm'
alias dstat-cpu='dstat -Tclr'
alias dstat-net='dstat -Tclnd'
alias dstat-disk='dstat -Tcldr'
#alias bundle='http_proxy= bundle'
alias jj="ruby -rjson -e 'jj JSON[ARGF.read]'"
alias vncstart="vncserver :1 -geometry 1920x1200"

[ -f ~/.zsh/.bundler-exec.sh ] && source ~/.zsh/.bundler-exec.sh
[[ -s ~/.tmuxinator/scripts/tmuxinator ]] && source ~/.tmuxinator/scripts/tmuxinator
if which rbenv > /dev/null; then eval "$(rbenv init - zsh)"; fi

