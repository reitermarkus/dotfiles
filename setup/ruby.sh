#!/bin/sh

gem_install() {

  local gem
  local name

  local OPTIND
  while getopts ":g:n:" o; do
    case "${o}" in
      g)  gem="${OPTARG}";;
      n) name="${OPTARG}";;
    esac
  done
  shift $((OPTIND-1))

  [ -z "${name}" ] && name=${gem}

  if array_contains_exactly "${gems}" "${gem}"; then
    cecho "${name} is already installed." $green
  else
    cecho "Installing ${name} …" $blue
    gem install "${gem}"
  fi

}

if hash gem; then


  gems=$(gem list | awk '{print $1}')


  # Install Ruby Gems

  gem_install -g bundler -n Bundler

fi