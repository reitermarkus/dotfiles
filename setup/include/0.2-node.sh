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

  if array_contains_exactly "${npm_packages}" "${package}"; then
    echo -g "${name} is already installed."
  else
    echo -b "Installing ${name} …"
    npm install -g "${package}"
  fi

}

install_npm_packages() {

  local npm_packages

  if npm_packages=$(npm -g list | awk '{print $NF}' | sed 's/@.*$//' | sed '1d;$d'); then

    # Install Node Packages

    brew-cask ls imageoptim &>/dev/null && npm_install -p imageoptim
    npm_install -p svgexport

  fi
}

