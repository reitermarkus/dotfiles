#!/bin/sh


# Install NPM Packages

npm_install_if_missing() {
  if hash "$1"; then
    cecho "“$1” already installed." $green
  else
    if hash npm; then
      cecho 'Installing “$1” …'
      npm install -g "$1"
    fi
  fi
}

brew cask ls imageoptim &>/dev/null && npm_install_if_missing imageoptim
npm_install_if_missing svgexport
