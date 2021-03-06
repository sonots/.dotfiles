# gcloud switch
export GX_CONFIG_DIR=$HOME/.gx-config
function gx-init() {
  name="$1" # alias
  if [ -z "$1" ]; then
    echo "gx-init <name> [project]"
    return 1
  fi
  if [ -z "$2" ]; then
    project="$name"
  else
    project="$2"
  fi
  set -x
  gx-activate "${name}"
  gcloud config configurations create "${name}"
  gcloud config set project "${project}"
  gcloud auth login
  gkx-init
  set +x
}
function gx-activate() {
  name="$1"
  export CLOUDSDK_CONFIG="${GX_CONFIG_DIR}/${name}"
}
function gx-current() {
  echo ${CLOUDSDK_CONFIG##*/}
}
function gx-complete() {
  _values "gcloud-config" $(\ls "${GX_CONFIG_DIR}")
}
function gx() {
  name="$1"
  if [ -z "${name}" ]; then
    name=$(\ls "${GX_CONFIG_DIR}" | peco)
  fi
  if [ -z "${name}" ]; then return 1; fi
  gx-activate "${name}"
  gkx-activate-default
}
compdef gx-complete gx

function gke-get-credentials() {
  cluster="$1"
  zone_or_region="$2"
  if echo "${zone_or_region}" | grep '[^-]*-[^-]*-[^-]*' > /dev/null; then
    echo "gcloud container clusters get-credentials \"${cluster}\" --zone=\"${zone_or_region}\""
    gcloud container clusters get-credentials "${cluster}" --zone="${zone_or_region}"
  else
    echo "gcloud container clusters get-credentials \"${cluster}\" --region=\"${zone_or_region}\""
    gcloud container clusters get-credentials "${cluster}" --region="${zone_or_region}"
  fi
}
function gcloud-current-project() {
  gcloud config get-value project 2>/dev/null
}

# kubectl switch
export GKX_CONFIG_DIR=$HOME/.gkx-config
function gkx-init() {
  name=$(gx-current)
  rm -r "${GKX_CONFIG_DIR}/${name}"
  gcloud container clusters list | tail -n +2 |  while read line; do
    cluster=$(echo "${line}" | awk '{print $1}')
    zone_or_region=$(echo "${line}" | awk '{print $2}')
    gkx-activate "${name}" "${cluster}"
    gke-get-credentials "${cluster}" "${zone_or_region}"
  done
}
function gkx-activate-default() {
  name=$(gx-current)
  if [ -d "${GKX_CONFIG_DIR}/${name}" ]; then
    cluster=$(\ls "${GKX_CONFIG_DIR}/${name}" | head -n 1)
    export KUBECONFIG="${GKX_CONFIG_DIR}/${name}/${cluster}"
  else
    unset KUBECONFIG
  fi
}
function gkx-activate() {
  name="$1"
  cluster="$2"
  export KUBECONFIG="${GKX_CONFIG_DIR}/${name}/${cluster}"
}
function gkx-current() {
  echo ${KUBECONFIG##*/}
}
function gkx-complete() {
  name=$(gx-current)
  _values "gke-config" $(\ls "${GKX_CONFIG_DIR}/${name}")
}
function gkx() {
  cluster="$1"
  name=$(gx-current)
  if [ -z "${cluster}" ]; then
    cluster=$(\ls "${GKX_CONFIG_DIR}/${name}" | peco)
  fi
  gkx-activate "${name}" "${cluster}"
}
compdef gkx-complete gkx
