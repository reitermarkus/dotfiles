#!/bin/sh

gem_polish() {

  if gem list | grep "^$1 " &>/dev/null; then
    echo_exists "$2"
  else
    echo_install "$2"
    gem install $1
  fi

}

if hash gem; then

  # Install Gems

  gem_polish bundler Bundler

}
