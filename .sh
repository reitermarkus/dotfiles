#!/bin/sh


# Ask for superuser password, and keep “sudo” alive.

sudo -v
while true; do sudo -n true; sleep 60; kill -0 "$$" || exit; done 2>/dev/null &


# Disable Ctrl-Z
trap '' SIGTSTP


# Prevent System Sleep

caffeinate -dimu -w $$ &


# Download Repository

if [ "$(basename "${0}")" != '.sh' ]; then
  eval "$(curl --silent --location "https://raw.githubusercontent.com/reitermarkus/dotfiles/HEAD/include/functions/echo.sh")"
  echo -b "Downloading Github Repository …"

  dotfiles_dir='/tmp/dotfiles-master'
  rm -rf "${dotfiles_dir}"
  curl --progress-bar --location 'https://github.com/reitermarkus/dotfiles/archive/master.zip' | ditto -xk - '/tmp'

  remove_dotfiles_dir() {
    echo -r 'Removing Dotfiles directory …'
    rm -rf "${dotfiles_dir}"
  }
else
  dotfiles_dir=$(cd "$(dirname "$0")"; pwd)
fi


# Load Functions

eval $(find "${dotfiles_dir}/include" -iname '*.sh' -exec echo . '{};' \;)


# Trap Ctrl-C
trap 'echo -r "\nAborting …"; exit 1' SIGINT


# Run Scripts

enable_assistive_access

install_xcode_clt
install_xcode

install_brew
install_brew_taps
install_brew_formulae

install_ruby_gems
install_npm_packages

install_brew_cask_apps
install_appstore_apps

dropbox_link_folders
mackup_relink

run_local_scripts

pids=()

for defaults in \
  startup \
  locale \
  locate_db \
  loginwindow \
  softwareupdate \
  keyboard \
  mouse_trackpad \
  ui_ux \
  finder \
  dock \
  menubar \
  bash \
  bettersnaptool \
  boom \
  fish \
  deliveries \
  hazel \
  keka \
  launchbar \
  parallels_desktop \
  safari \
  savehollywood \
  terminal \
  tower \
  transmission \
  xcode
do
  defaults_${defaults} & pids+=(${!})
done

for pid in ${pids[*]}; do
  wait ${pid}
done

apply_defaults

cleanup

check_if_xcode_is_installed

echo -k 'Done.'
