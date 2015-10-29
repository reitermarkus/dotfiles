#!/bin/sh


# Set the colours you can use

black='\033[0;30m'
white='\033[0;37m'
red='\033[0;31m'
green='\033[0;32m'
yellow='\033[0;33m'
blue='\033[0;34m'
magenta='\033[0;35m'
cyan='\033[0;36m'


# Resets the style

reset=`tput sgr0`


# Colored “echo”

cecho() {
  echo "${2}${1}${reset}"
  return
}


# Installation Messages

echo_exists() {
  cecho "$1 is already installed." $green
}

echo_install() {
  cecho "Installing $1 …" $blue
}

echo_error() {
  cecho "$1" $red
}


# Keep-alive “sudo”.

sudo -v
while true; do
  sudo -n true; sleep 60; kill -0 "$$" || exit;
done 2>/dev/null &


# Check if Mac has an internal Battery.

ioreg -l | grep DesignCapacity &>/dev/null && is_mobile=true


# Grant Assistive Access to Terminal and “osascript”.

sudo sqlite3 <<EOF
.open '/Library/Application Support/com.apple.TCC/TCC.db'
insert or replace into access values('kTCCServiceAccessibility','com.apple.Terminal',0,1,1,NULL,NULL);
insert or replace into access values('kTCCServiceAccessibility','$(which osascript)',1,1,1,NULL,NULL);
.quit
EOF


# Install Command Line Developer Tools

if xcode-select --print-path &>/dev/null; then
  cecho 'Command Line Developer Tools are already installed.' $green
else
  cecho 'Installing Command Line Developer Tools …' $blue

  touch '/tmp/.com.apple.dt.CommandLineTools.installondemand.in-progress'
  CLDT=$(softwareupdate --list | grep "\*.*Command Line" | head -n 1 | awk -F"*" '{print $2}' | sed -e 's/^ *//' | tr -d '\n')
  softwareupdate --install "${CLDT}" --verbose | grep '%'
fi


# Clone Repository


if [[ "$(basename ${0})" != '.sh' ]]; then
  cecho 'Downloading Github Repository …' $blue
  dotfiles_dir='/tmp/dotfiles-master'
  rm -rf "${dotfiles_dir}"
  curl --progress-bar --location 'https://github.com/reitermarkus/dotfiles/archive/master.zip' | ditto -xk - '/tmp'
else
  dotfiles_dir=$(cd "$(dirname "$0")"; pwd)
fi


# Run Scripts

source "$dotfiles_dir/setup/tools.array.sh"

source "$dotfiles_dir/setup/defaults.sh"
source "$dotfiles_dir/setup/appstore.sh"
source "$dotfiles_dir/setup/brew.sh"
source "$dotfiles_dir/setup/node.sh"
source "$dotfiles_dir/setup/ruby.sh"
source "$dotfiles_dir/setup/fish.sh"
source "$dotfiles_dir/setup/dock.sh"
source "$dotfiles_dir/setup/dropbox.sh"
source "$dotfiles_dir/setup/cleanup.sh"
