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
    echo "\033[0;31mPlease enable Accessibility Access for 'Terminal.app' in System Preferences.\033[0m"
    exit 1
  fi

  # Download Repository

  if [ "$(basename "${0}")" != '.sh' ]; then
    echo '\033[0;34mDownloading Github Repository …\033[0m'

    dotfiles_dir='/tmp/dotfiles-master'
    /bin/rm -rf "${dotfiles_dir}"

    remove_dotfiles_dir() {
      echo '\033[0;31mRemoving Dotfiles directory …\033[0m'
      /bin/rm -rf "${dotfiles_dir}"
    }
    at_exit remove_dotfiles_dir

    /usr/bin/curl --progress-bar --location 'https://github.com/reitermarkus/dotfiles/archive/master.zip' | ditto -xk - '/tmp'
  else
    dotfiles_dir=$(cd "$(/usr/bin/dirname "$0")" || exit 1; pwd)
  fi

  cd "${dotfiles_dir}"

  if ! ci; then
    # Ask for superuser password, and temporarily add it to the Keychain.

    SUDO_ASKPASS_SCRIPT="$(mktemp)"

    echo \
      "#!/bin/sh\n" \
      '/usr/bin/security find-generic-password -s "dotfiles" -a "$USER" -w' \
      >> "${SUDO_ASKPASS_SCRIPT}"

    /bin/chmod +x "${SUDO_ASKPASS_SCRIPT}"

    delete_askpass_password() {
      echo '\033[0;31mRemoving password from Keychain …\033[0m'
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
      echo '\033[0;31mIncorrect password. Exiting …\033[0m'
      exit 1
    fi
  fi


  # Trap Ctrl-C
  trap 'trap "" INT; echo "\n\033[0;31mAborting …\033[0m"; cleanup; exit 1' INT


  # Run Scripts

  /usr/bin/rake \
    files \
    xcode:command_line_utilities \
    brew \
    ruby \
    rust \
    mas \
    xcode:accept_license \
    dropbox \
    mackup \
    local_scripts \
    bash \
    fish \
    git \
    xcode:defaults \
    rapidclick \
    hazel \
    virtualbox \
    steam \
    csgo \
    tex \
    ccache \
    sccache \
    make \
    keyboard \
    ui \
    rocket \
    safari \
    locale \
    startup \
    transmission \
    locate_db \
    menubar \
    deliveries \
    tower \
    bettersnaptool \
    screensaver \
    vagrant \
    telegram \
    finder \
    crash_reporter \
    dnsmasq \
    loginwindow \
    textmate \
    dock \
    softwareupdate \
    terminal \
    rfc \
    z \
    keka \
    arduino \
    mouse_trackpad

  at_exit 'echo "\033[0;30mDone.\033[0m"'

}
