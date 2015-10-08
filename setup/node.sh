#!/bin/sh


# Install NPM Packages

npm_install_if_missing() {
  
  if npm -g ls | awk '{ print $NF }' | grep "^$1@" &>/dev/null; then
    echo_exists "$1"
  else
    echo_install "$1"
    npm install -g "$1"
  fi
}

if hash npm; then

  brew cask ls imageoptim &>/dev/null && npm_install_if_missing imageoptim
  npm_install_if_missing svgexport

fi
