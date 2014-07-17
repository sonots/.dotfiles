# ghq & peco
function d() {
  if [ -n "$1" ]; then
    # ghq look $1
    builtin cd $(ghq list -p | grep $1 | head -1)
  else
    builtin cd $(ghq list -p | peco)
  fi
}

function p() {
  if [ -n "$1" ]; then
    ghq list -p | grep $1
  else
    ghq list -p | peco
  fi
}

function b() {
  if [ -n "$1" ]; then
    open "https://$(ghq list | grep $1 | head -1)"
  else
    open "https://$(ghq list | peco)"
  fi
}

# bundler & peco
function cdgem() {
  if [ -n "$1" ]; then
    builtin cd $(bundle show $1)
  else
    builtin cd $(bundle show --paths | peco)
  fi
}

# golang & peco
alias godoc='\godoc $(ghq list -p | peco) | $PAGER'
# build-in command & peco
function cd() {
  if [ -n "$1" ]; then
    builtin cd $1
  else
    builtin cd $(\ls -F | grep / | peco)
  fi
}
  
function bundol () {
  if [ -e Gemfile ]; then
    mkdir -p /tmp/$(pwd)
    sed -e "s|gemspec.*|gemspec path: \"$(pwd)\"|" Gemfile > /tmp/$(pwd)/Gemfile
    echo 'gem "pry"' >> /tmp/$(pwd)/Gemfile
    echo 'gem "pry-nav"' >> /tmp/$(pwd)/Gemfile
    bundle --gemfile=/tmp/$(pwd)/Gemfile
  else
    echo 'Gemfile is not found' 1>&2
  fi
}

function be () {
  if [ -e /tmp/$(pwd)/Gemfile ]; then
    BUNDLE_GEMFILE=/tmp/$(pwd)/Gemfile RUBYOPT="-r pry" bundle exec $@
  else
    bundle exec $@
  fi
}
alias be="nocorrect be"

function run_httpd() {
  ruby -run -e httpd -- -p 8080 .
}
