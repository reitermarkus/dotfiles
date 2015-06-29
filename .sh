#!/bin/sh
echo $0

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


# Clone Repository

git_dir=/tmp/dotfiles
cecho 'Cloning Git Repository …' $blue
rm -rf /tmp/dotfiles && git clone https://github.com/reitermarkus/dotfiles.git $git_dir


# Run “sudo” keep-alive.

sudo -v
while true; do sudo -n true; sleep 60; kill -0 "$$" || exit; done 2>/dev/null &


# Grant Terminal access to Assistive Features

sudo python <<EOF
import sqlite3
conn = sqlite3.connect('/Library/Application Support/com.apple.TCC/TCC.db')
conn.cursor().execute("INSERT or REPLACE INTO access VALUES('kTCCServiceAccessibility','com.apple.Terminal',0,1,1,NULL,NULL)")
conn.cursor().execute("INSERT or REPLACE INTO access VALUES('kTCCServiceAccessibility','$(which osascript)',1,1,1,NULL,NULL)")
conn.commit()
conn.close()
EOF


# Run Scripts

source "$git_dir/setup/defaults.sh"
source "$git_dir/setup/app-store.sh"
source "$git_dir/setup/brew.sh"
source "$git_dir/setup/fish.sh"
source "$git_dir/setup/dropbox.sh"
source "$git_dir/setup/cleanup.sh"
