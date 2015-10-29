#!/bin/sh

npm_install() {

  local package
  local name

  local OPTIND
  while getopts ":p:n:" o; do
    case "${o}" in
      p) package="${OPTARG}";;
      n)    name="${OPTARG}";;
    esac
  done
  shift $((OPTIND-1))

  [ -z "${name}" ] && name=${package}

  if array_contains_exactly "${npms}" "${package}"; then
    cecho "${name} is already installed." $green
  else
    cecho "Installing ${name} …" $blue
    npm install -g "${package}"
  fi

}

if hash npm; then


  npms=$(npm -g list | awk '{print $NF}' | sed 's/@.*$//' | sed '1d;$d')


  # Install Node Packages

  brew-cask ls imageoptim &>/dev/null && npm_install -p imageoptim
  npm_install -p svgexport

fi
