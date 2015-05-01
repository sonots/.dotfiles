# ^r to see history using peco
function peco-select-history() {
    local tac
    if which tac > /dev/null; then
        tac="tac"
    else
        tac="tail -r"
    fi
    BUFFER=$(\history -n 1 | \
        eval $tac | \
        peco --query "$LBUFFER")
    CURSOR=$#BUFFER
    zle clear-screen
}
zle -N peco-select-history
bindkey '^r' peco-select-history

# d [pattern] to chdir to ghq directory
function d() {
  if [ -n "$1" ]; then
    # ghq look $1
    builtin cd $(ghq list -p | grep -i $1 | head -1)
  else
    builtin cd $(ghq list -p | peco)
  fi
}

# p [pattern] to print ghq directory
function p() {
  if [ -n "$1" ]; then
    ghq list -p | grep -i $1
  else
    ghq list -p | peco
  fi
}

# v [pattern] to vim a file under the current directory
function v() {
  if [ -n "$1" ]; then
    vim $(find . -type f -o -name .git -prune | grep -i $1 | head -1)
  else
    vim $(find . -type f -o -name .git -prune | peco)
  fi
}

# o [pattern] to open ghq git repository url (works on MacOSX)
function o() {
  if [ -n "$1" ]; then
    open "https://$(ghq list | grep -i $1 | head -1)"
  else
    open "https://$(ghq list | peco)"
  fi
}

# s [pattern] to print ghq git repository url
function s() {
  if [ -n "$1" ]; then
    echo "https://$(ghq list | grep -i $1 | head -1)"
  else
    echo "https://$(ghq list | peco)"
  fi
}

# b [pattern] to checkout git branch
function b() {
  if [ -n "$1" ]; then
    local branch=$(git branch -a | grep -i $1 | head -1 | tr -d ' ')
  else
    local branch=$(git branch -a | peco | tr -d ' ')
  fi
  if [ -n "$branch" ]; then
    if [[ "$branch" =~ "remotes/" ]]; then
      local b=$(echo $branch | awk -F '/' '{print $3}')
      git checkout -b $b $branch
    else
      git checkout $branch
    fi
  fi
}

# cdgem [pattern] to chdir to gem directory
function cdgem() {
  if [ -n "$1" ]; then
    builtin cd $(bundle show $1)
  else
    builtin cd $(bundle show --paths | peco)
  fi
}

# godoc [pattern] to see golang document
alias godoc='\godoc $(ghq list -p | peco) | $PAGER'
# build-in command & peco
# function cd() {
#   if [ -n "$1" ]; then
#     builtin cd $1
#   else
#     builtin cd $(\ls -F | grep / | peco)
#   fi
# }

function pps() {
  res=$(ps aux | peco | awk '{print $2}')
}

function pssh() {
  local res=$(grep "Host " ~/.ssh/config | cut -d \  -f 2 | peco)
  if [ -n "$res" ]; then
    ssh $res
  fi
}
