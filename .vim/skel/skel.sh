#!/bin/bash
set -e
export PATH="/bin:/usr/bin:/usr/local/bin"

main() {
  if [ -z "${ID}" ]; then
    printf "ID: "
    read ID
  fi

  if [ -z "${PASSWORD}" ]; then
    stty -echo
    printf "PASSWORD: "
    read PASSWORD
    stty echo
  fi
}

usage() {
  echo "SYNOPSIS:"
  echo "    $(basename ${0}) [OPTIONS]"
  echo ""
  echo "OPTIONS:"
  echo ""
  echo "    -d:"
  echo "        debug mode (set -x)"
  echo "    -l LOGPATTERN:"
  echo "        The log filename pattern to watch. Ex) /var/log/boot.log to watch /var/log/boot.log.{1,2,3,...}"
  echo "    -p POSITIONFILE:"
  echo "        The path of file to store log position"
  echo "    -i INITLINE:"
  echo "        The number of lines to read at the first run (To prohibit reading entire lines)"
  exit 1
}

while getopts "l:p:i:dh" OPTION; do
  case ${OPTION} in
    l) LOGPATTERN=${OPTARG};;
    p) POSITIONFILE=${OPTARG};;
    i) INITLINE=${OPTARG};;
    d) set -x;;
    h) usage;;
    ?) usage;;
  esac
done
shift `expr ${OPTIND} - 1`

main

