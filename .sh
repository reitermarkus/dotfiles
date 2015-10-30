#!/bin/sh

# Ask for superuser password, and keep “sudo” alive.

sudo -v
while true; do sudo -n true; sleep 60; kill -0 "$$" || exit; done 2>/dev/null &


# Download Repository

if [[ "$(basename ${0})" != '.sh' ]]; then
  eval "$(curl -s "https://raw.githubusercontent.com/reitermarkus/dotfiles/HEAD/setup/include/0.0-echo.sh")"
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


# Check if Mac has an internal Battery.

ioreg -l | grep DesignCapacity &>/dev/null && is_mobile=true


trap 'exit 0' SIGINT

for script in "$dotfiles_dir/setup/include/"*.sh; do
  source "${script}"
done


caffeinate_start


# Run Scripts

enable_assistive_access

install_xcode_clt
install_xcode

source "$dotfiles_dir/setup/defaults.sh"

install_brew
install_brew_taps
install_brew_packages
install_brew_cask

install_ruby_gems
install_npm_packages

set_default_shell_to_fish

install_brew_cask_apps
install_appstore_apps

rearrange_dock

dropbox_link_folders
mackup_relink

run_local_scripts

defaults_startup
defaults_locale

cleanup
caffeinate_stop

echo -k 'Done.'
