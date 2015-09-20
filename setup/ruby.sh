#!/bin/sh

if hash gem; then

  install_gem_if_missing() {

    if ! gem list | grep "^$1 " &>/dev/null; then
      echo_install "$2"
      gem install $1
    else
      echo_exists "$2"
    fi
  }

  # Install Gems
  install_gem_if_missing bundler Bundler

}
