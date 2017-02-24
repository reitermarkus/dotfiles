#!/bin/sh

{

  # Disable Ctrl-Z

  trap '' TSTP


  # Prevent System Sleep

  /usr/bin/caffeinate -dimu -w $$ &


  # Add commands to run when exiting.

  at_exit() {
    if [ ! -z "${AT_EXIT}" ]; then
      AT_EXIT+=';'
    fi

    AT_EXIT+="${*}"
    trap "${AT_EXIT}" EXIT
  }


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


  # Load Functions

  eval "$(/usr/bin/find "${dotfiles_dir}/include" -iname '*.sh' -exec echo . '{};' \;)"


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

  with_askpass() {
    SUDO_ASKPASS="${SUDO_ASKPASS_SCRIPT}" "${@}"
  }

  sudo() {
    with_askpass /usr/bin/sudo -A "${@}"
  }

  /usr/bin/security add-generic-password -U -s 'dotfiles' -a "${USER}" -w "$(read -s -p "Password:" P < /dev/tty && printf "${P}")"
  printf "\n"

  sudo -k
  if ! sudo -kv 2>/dev/null; then
    echo -r 'Incorrect password. Exiting …'
    exit 1
  fi


  # Trap Ctrl-C
  trap 'trap "" INT; echo -r "\nAborting …"; cleanup; exit 1' INT


  # Run Scripts

  install_xcode_clt

  install_brew
  install_brew_taps
  install_brew_formulae

  install_ruby_gems
  install_npm_packages

  install_brew_casks
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
    environment
    fish
    deliveries
    hazel
    keka
    launchbar
    rapidclick
    safari
    savehollywood
    ssh
    telegram
    terminal
    tower
    transmission
    vagrant
    virtualbox
    xcode
  )

  for default in "${defaults[@]}";do
    "defaults_${default}"
  done

  apply_defaults

  cleanup

  at_exit 'echo -k "Done."'

}
