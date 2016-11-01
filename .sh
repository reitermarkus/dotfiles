#!/bin/sh


# Disable Ctrl-Z

trap '' TSTP


# Prevent System Sleep

/usr/bin/caffeinate -dimu -w $$ &


# Download Repository

if [ "$(basename "${0}")" != '.sh' ]; then
  eval "$(/usr/bin/curl --silent --location "https://raw.githubusercontent.com/reitermarkus/dotfiles/HEAD/include/functions/echo.sh")"
  echo -b "Downloading Github Repository …"

  dotfiles_dir='/tmp/dotfiles-master'
  /bin/rm -rf "${dotfiles_dir}"

  remove_dotfiles_dir() {
    echo -r 'Removing Dotfiles directory …'
    /bin/rm -rf "${dotfiles_dir}"
  }

  trap remove_dotfiles_dir EXIT

  /usr/bin/curl --progress-bar --location 'https://github.com/reitermarkus/dotfiles/archive/master.zip' | ditto -xk - '/tmp'
else
  dotfiles_dir=$(cd "$(/usr/bin/dirname "$0")" || exit 1; pwd)
fi


# Load Functions

eval "$(/usr/bin/find "${dotfiles_dir}/include" -iname '*.sh' -exec echo . '{};' \;)"


# Ask for superuser password, and add $USER to /etc/sudoers for the duration of the script.

/usr/bin/sudo -v || exit 1

USER_SUDOER="${USER} ALL=(ALL) NOPASSWD: ALL"

reset_sudoers() {
  echo -b 'Resetting /etc/sudoers …'
  /usr/bin/sudo -E -- /usr/bin/sed -i '' "/^${USER_SUDOER}/d" /etc/sudoers
}

if type remove_dotfiles_dir &>/dev/null; then
  trap 'remove_dotfiles_dir; reset_sudoers' EXIT
else
  trap reset_sudoers EXIT
fi

echo "${USER_SUDOER}" | /usr/bin/sudo -E -- /usr/bin/tee -a /etc/sudoers >/dev/null


# Trap Ctrl-C
trap 'trap "" INT; echo -r "\nAborting …"; cleanup; exit 1' INT


# Run Scripts

install_xcode_clt

install_brew
install_brew_taps
install_brew_formulae

install_ruby_gems
install_npm_packages

install_brew_cask_apps
install_mas_apps

dropbox_link_folders
mackup_relink

run_local_scripts

defaults=(
  startup
  locale
  locate_db
  loginwindow
  softwareupdate
  keyboard
  mouse_trackpad
  ui_ux
  crash_reporter
  finder
  dock
  menubar
  adobe
  bash
  bettersnaptool
  boom
  fish
  deliveries
  hazel
  keka
  launchbar
  rapidclick
  safari
  savehollywood
  ssh
  terminal
  tower
  transmission
  xcode
)

for default in "${defaults[@]}";do
  defaults_${default}
done

apply_defaults

cleanup

echo -k 'Done.'
