ROOT_DIR=$HOME/.zsh
source $ROOT_DIR/peco.zsh

#function bundol () {
#  if [ -e Gemfile ]; then
#    mkdir -p /tmp/$(pwd)
#    sed -e "s|gemspec.*|gemspec path: \"$(pwd)\"|" Gemfile > /tmp/$(pwd)/Gemfile
#    echo 'gem "pry"' >> /tmp/$(pwd)/Gemfile
#    echo 'gem "pry-nav"' >> /tmp/$(pwd)/Gemfile
#    bundle --gemfile=/tmp/$(pwd)/Gemfile
#  else
#    echo 'Gemfile is not found' 1>&2
#  fi
#}

function gcloud-open() {
  project=$(gcloud-current-project)
  url="https://console.cloud.google.com/home/dashboard?project=${project}"
  open "$url"
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

function touch_p() {
  dir=$(dirname $1)
  mkdir -p $dir
  touch $1
}

function git-create-repo() {
  curl -u sonots https://api.github.com/user/repos -d "{\"name\":\"$1\"}"
}
