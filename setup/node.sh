#!/bin/sh

node_fasten() {

  if npm -g ls | awk '{ print $NF }' | grep "^$1@" &>/dev/null; then
    echo_exists "$1"
  else
    echo_install "$1"
    npm install -g "$1"
  fi

}

if hash npm; then

  # Install NPM Packages

  brew-cask ls imageoptim &>/dev/null && node_fasten imageoptim
  node_fasten svgexport

fi
