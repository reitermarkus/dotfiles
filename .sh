#!/bin/sh

{

  # Abort on errors.

  set -e
  set -o pipefail


  # Abort on unbound variables.

  set -u


  # Disable Ctrl-Z

  trap '' TSTP


  # Prevent System Sleep

  /usr/bin/caffeinate -dimu -w $$ &


  # Add commands to run when exiting.

  at_exit() {
    AT_EXIT+="${AT_EXIT:+;}"
    AT_EXIT+="${*?}"
    trap "${AT_EXIT}" EXIT
  }

  ci() {
    test -n "${CI+set}"
  }

  # Accessibility Access

  if ! ci && test -z "$(/usr/bin/sqlite3 '/Library/Application Support/com.apple.TCC/TCC.db' \
                       "SELECT * FROM access WHERE client = 'com.apple.Terminal' AND allowed = 1")"; then
    echo -r "Please enable Accessibility Access for 'Terminal.app' in System Preferences."
    exit 1
  fi


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
    at_exit remove_dotfiles_dir

    /usr/bin/curl --progress-bar --location 'https://github.com/reitermarkus/dotfiles/archive/master.zip' | ditto -xk - '/tmp'
  else
    dotfiles_dir=$(cd "$(/usr/bin/dirname "$0")" || exit 1; pwd)
  fi


  # Load Environment
  source "${dotfiles_dir}/~/.config/environment"


  # Load Functions

  eval "$(/usr/bin/find "${dotfiles_dir}/include" -iname '*.sh' -exec echo . '{};' \;)"


  if ! ci; then
    # Ask for superuser password, and temporarily add it to the Keychain.

    SUDO_ASKPASS_SCRIPT="$(mktemp)"

    echo \
      "#!/bin/sh\n" \
      '/usr/bin/security find-generic-password -s "dotfiles" -a "$USER" -w' \
      >> "${SUDO_ASKPASS_SCRIPT}"

    /bin/chmod +x "${SUDO_ASKPASS_SCRIPT}"

    delete_askpass_password() {
      echo -r 'Removing password from Keychain …'
      /bin/rm -f "${SUDO_ASKPASS_SCRIPT}"
      /usr/bin/security delete-generic-password -s 'dotfiles' -a "${USER}"
    }
    at_exit delete_askpass_password

    export SUDO_ASKPASS="${SUDO_ASKPASS_SCRIPT}"

    sudo() {
      /usr/bin/sudo -A "${@}"
    }

    /usr/bin/security add-generic-password -U -s 'dotfiles' -a "${USER}" -w "$(read -s -p "Password: " P < /dev/tty && printf "${P}")"
    printf "\n"

    sudo -k
    if ! sudo -kv 2>/dev/null; then
      echo -r 'Incorrect password. Exiting …'
      exit 1
    fi
  fi


  # Trap Ctrl-C
  trap 'trap "" INT; echo -r "\nAborting …"; cleanup; exit 1' INT


  # Run Scripts

  install_files

  /usr/bin/rake xcode:command_line_utilities

  /usr/bin/rake brew

  /usr/bin/rake ruby
  install_npm_packages

  /usr/bin/rake rust

  /usr/bin/rake mas:apps

  /usr/bin/rake xcode:accept_license

  /usr/bin/rake dropbox:all

  mackup_relink

  run_local_scripts

  /usr/bin/rake bash
  /usr/bin/rake fish
  /usr/bin/rake git

  /usr/bin/rake xcode:defaults
  /usr/bin/rake rapidclick:defaults
  /usr/bin/rake hazel:defaults
  /usr/bin/rake virtualbox:defaults
  /usr/bin/rake steam:defaults
  /usr/bin/rake csgo:config
  /usr/bin/rake tex
  /usr/bin/rake ccache
  /usr/bin/rake make
  /usr/bin/rake keyboard
  /usr/bin/rake ui
  /usr/bin/rake rocket
  /usr/bin/rake safari
  /usr/bin/rake locale
  /usr/bin/rake startup
  /usr/bin/rake transmission
  /usr/bin/rake locate_db
  /usr/bin/rake menubar
  /usr/bin/rake deliveries
  /usr/bin/rake tower
  /usr/bin/rake bettersnaptool
  /usr/bin/rake screensaver
  /usr/bin/rake vagrant
  /usr/bin/rake telegram
  /usr/bin/rake finder
  /usr/bin/rake crash_reporter
  /usr/bin/rake dnsmasq

  defaults=(
    loginwindow
    softwareupdate
    mouse_trackpad
    dock
    keka
    terminal
    textmate
  )

  for default in "${defaults[@]}"; do
    "defaults_${default}"
  done

  /usr/bin/killall cfprefsd &>/dev/null

  at_exit 'echo -k "Done."'

}
