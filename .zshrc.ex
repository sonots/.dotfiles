# aws switch
export AWS_CONFIG_FILE=$HOME/.aws/config
# export AWS_SHARED_CREDENTIALS_FILE=$HOME/.aws/credentials
function aws-profiles() {
  cat "${AWS_CONFIG_FILE}" | sed -n "s/^\[profile \(.*\)\]$/\1/p"
}
function ex-init() {
  profile="$1"
  if [ -z "$1" ]; then
    echo "ex-init <profile>"
    return 1
  fi
  unset AWS_DEFAULT_PROFILE
  unset AWS_PROFILE
  ex-activate "${profile}"
  ekx-init
}
function ex-activate() {
  profile="$1"
  export AWS_DEFAULT_PROFILE="${profile}"
  export AWS_PROFILE="${profile}"
}
function ex-current() {
  echo "${AWS_PROFILE}"
}
function ex-complete() {
  _values "ex-complete" $(aws-profiles)
}
function ex() {
  profile="$1"
  if [ -z "${profile}" ]; then
    profile=$(aws-profiles | peco)
  fi
  if [ -z "${profile}" ]; then return 1; fi
  ex-activate "${profile}"
  ekx-activate-default
}
compdef ex-complete ex

# kubectl switch
export EKX_CONFIG_DIR=$HOME/.ekx-config
function ekx-init() {
  profile=$(ex-current)
  rm -rf "${EKX_CONFIG_DIR}/${profile}"
  aws eks list-clusters | jq -r '.clusters[]' |  while read cluster; do
    ekx-activate "${profile}" "${cluster}"
    aws eks update-kubeconfig --name "${cluster}"
  done
}
function ekx-activate-default() {
  profile=$(ex-current)
  if [ -d "${EKX_CONFIG_DIR}/${profile}" ]; then
    cluster=$(\ls "${EKX_CONFIG_DIR}/${profile}" | head -n 1)
    export KUBECONFIG="${EKX_CONFIG_DIR}/${profile}/${cluster}"
  else
    unset KUBECONFIG
  fi
}
function ekx-activate() {
  profile="$1"
  cluster="$2"
  export KUBECONFIG="${EKX_CONFIG_DIR}/${profile}/${cluster}"
}
function ekx-current() {
  echo ${KUBECONFIG##*/}
}
function ekx-complete() {
  profile=$(ex-current)
  _values "ekx-complete" $(\ls "${EKX_CONFIG_DIR}/${profile}")
}
function ekx() {
  cluster="$1"
  profile=$(ex-current)
  if [ -z "${cluster}" ]; then
    cluster=$(\ls "${EKX_CONFIG_DIR}/${profile}" | peco)
  fi
  ekx-activate "${profile}" "${cluster}"
}
compdef ekx-complete ekx
