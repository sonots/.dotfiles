source peco.zsh

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
