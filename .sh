#!/bin/bash

{

  # Abort on errors.
  set -e
  set -o pipefail

  # Abort on unbound variables.
  set -u

  # Disable Ctrl-Z.
  trap '' TSTP

  # Trap Ctrl-C.
  trap 'trap "" INT; echo "\n\033[0;31mAborting …\033[0m" 1>&2; exit 1' INT

  # Prevent system sleep.
  /usr/bin/caffeinate -dimu -w $$ &

  # Add exit handlers.
  at_exit() {
    AT_EXIT+="${AT_EXIT:+$'\n'}"
    AT_EXIT+="${*?}"
    # shellcheck disable=SC2064
    trap "${AT_EXIT}" EXIT
  }

  ci() {
    ${CI+true}
    ${CI-false}
  }

  if ! ci; then
    if [ "$(printf '%s' "$(/usr/bin/sw_vers -productVersion)\n10.14" | /usr/bin/sort -V | /usr/bin/head -n 1)" = '10.14' ]; then
      # Full Disk Access
      if { ! test -r "${HOME}/Library/Application Support/com.apple.TCC/TCC.db" 2>&1; } | grep -q 'Operation not permitted'; then
        echo 'Add “Terminal.app” to System Preferences -> Security -> Privacy -> Full Disk Access' 1>&2
        /usr/bin/open 'x-apple.systempreferences:com.apple.preference.security?Privacy_AllFiles'
        /usr/bin/open -R /Applications/Utilities/Terminal.app
        exit 1
      fi

      if test -z "$(/usr/bin/sqlite3 "${HOME}/Library/Application Support/com.apple.TCC/TCC.db" \
                      "SELECT * FROM access WHERE client = 'com.apple.Terminal' AND indirect_object_identifier = 'com.apple.systemevents' AND allowed = 1")"; then
        /usr/bin/sqlite3 "${HOME}/Library/Application Support/com.apple.TCC/TCC.db" "REPLACE INTO access VALUES('kTCCServiceAppleEvents','com.apple.Terminal',0,1,1,X'fade0c000000003000000001000000060000000200000012636f6d2e6170706c652e5465726d696e616c000000000003',NULL,0,'com.apple.systemevents',X'fade0c000000003400000001000000060000000200000016636f6d2e6170706c652e73797374656d6576656e7473000000000003',0,$(/bin/date +%s))"
      fi
    else
      # Accessibility Access
      if test -z "$(/usr/bin/sqlite3 '/Library/Application Support/com.apple.TCC/TCC.db' \
                      "SELECT * FROM access WHERE client = 'com.apple.Terminal' AND allowed = 1")"; then
        echo "\033[0;31mPlease enable Accessibility Access for 'Terminal.app' in System Preferences.\033[0m" 1>&2
        /usr/bin/open 'x-apple.systempreferences:com.apple.preference.security?Privacy_Accessibility'
        /usr/bin/open -R /Applications/Utilities/Terminal.app
        exit 1
      fi
    fi

    # Ask for superuser password, and temporarily add it to the Keychain.
    /usr/bin/security add-generic-password -U -s 'dotfiles' -a "${USER}" -w "$(read -r -s -p "Password: " P < /dev/tty && echo "${P}")"
    printf "\n"

    at_exit "
      echo '\033[0;31mRemoving password from Keychain …\033[0m'
      /usr/bin/security delete-generic-password -s 'dotfiles' -a '${USER}'
    "

    SUDO_ASKPASS="$(/usr/bin/mktemp)"

    at_exit "
      echo '\033[0;31mDeleting SUDO_ASKPASS script …\033[0m'
      /bin/rm -f '${SUDO_ASKPASS}'
    "

    {
      echo "#!/bin/sh"
      echo "/usr/bin/security find-generic-password -s 'dotfiles' -a '${USER}' -w"
    } > "${SUDO_ASKPASS}"

    /bin/chmod +x "${SUDO_ASKPASS}"

    export SUDO_ASKPASS

    if ! /usr/bin/sudo -A -kv 2>/dev/null; then
      echo '\033[0;31mIncorrect password.\033[0m' 1>&2
      exit 1
    fi
  fi

  # Use local version or download repository.
  if [ "$(/usr/bin/basename "${0}")" = '.sh' ]; then
    cd "$(/usr/bin/dirname "$0")"
  else
    echo '\033[0;34mDownloading Github Repository …\033[0m'

    dotfiles_dir="$(/usr/bin/mktemp -d)"
    pushd "${dotfiles_dir}" >/dev/null

    remove_dotfiles_dir() {
      echo '\033[0;31mRemoving Dotfiles directory …\033[0m'
      popd >/dev/null
      /bin/rm -rf "${dotfiles_dir}"
    }
    at_exit remove_dotfiles_dir

    /usr/bin/curl --progress-bar --location 'https://github.com/reitermarkus/dotfiles/archive/master.tar.gz' | /usr/bin/tar -x --strip-components 1
  fi

  # Run scripts.
  /usr/bin/rake \
    files \
    xcode:command_line_utilities \
    brew \
    ruby \
    rust \
    python \
    mas \
    xcode:accept_license \
    fonts \
    mackup \
    local_scripts \
    bash \
    fish \
    git \
    github \
    xcode:defaults \
    itunes \
    rapidclick \
    hazel \
    virtualbox \
    steam \
    csgo \
    cities_skylines \
    tex \
    ccache \
    sccache \
    make \
    pam \
    keyboard \
    ui \
    rocket \
    safari \
    locale \
    startup \
    transmission \
    locate_db \
    menubar \
    mediathekview \
    deliveries \
    tower \
    bettersnaptool \
    screensaver \
    parallels \
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
    x11 \
    z \
    keka \
    arduino \
    mouse_trackpad

  at_exit 'echo "\033[0;30mDone.\033[0m"'

}
