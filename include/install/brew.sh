install_brew() {

  # Install Homebrew
  sudo chown "${USER}" /usr/local/

  if type brew &>/dev/null; then
    echo -g 'Homebrew is already installed.'
  else
    echo -b 'Installing Homebrew …'
    ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
  fi

}


# Hombrew Install Function

brew_install() {

  local cask
  local name
  local appdir
  local package
  local tap
  local open=false

  local OPTIND
  while getopts ":c:d:p:t:n:o" o; do
    case "${o}" in
      c)    cask="${OPTARG}";;
      n)    name="${OPTARG}";;
      d)  appdir="${OPTARG}";;
      p) package="${OPTARG}";;
      t)     tap="${OPTARG}";;
      o)    open=true;;
    esac
  done
  shift $((OPTIND-1))

  if [ -n "${cask}" ]; then

    [ -z "${appdir}" ] && appdir=/Applications/

    if [ -z "${name}" ]; then
      OIFS=$IFS
      IFS=';'
      for caskname in $(brew cask _stanza name "${cask}" | sed 's/", "/\;/g' | tr -d '["]'); do
        name="${caskname}"
      done
      IFS=$OIFS
    fi

    if array_contains_exactly "${brew_casks}" "$(basename "${cask}")"; then
      echo -g "${name} is already installed."
    else
      echo -b "Installing ${name} …"

      mkdir -p "${appdir}"
      brew cask uninstall "${cask}" --force &>/dev/null
      brew cask install "${cask}" --force \
        --appdir="${appdir}" \
        --prefpanedir=/Library/PreferencePanes \
        --qlplugindir=/Library/QuickLook \
        --screen_saverdir=/Library/Screen\ Savers

      if [ "${open}" == true ]; then
        IFS=';'

        local apps=($(brew cask _stanza app "${cask}" | sed 's/", "/\;/g' | tr -d '["]'))

        if [ -z "${apps[@]}" ]; then
          apps="${name}"
        fi

        for app in ${apps[*]}; do
          echo -b "Opening ${app} …"
          local timeout=15
          let timeout*=10
          until open -jga "$(sed 's/\.app\$//' <<< "${app}")" &>/dev/null || [ "${timeout}" -lt 0 ]; do
            let timeout--
            sleep 0.1
          done &
        done

        IFS=$OIFS
      fi

    fi

  elif [ -n "${package}" ]; then

    [ -z "${name}" ] && name=${package}
    if array_contains_exactly "${brew_packages}" "$(basename "${package}")"; then
      echo -g "${name} is already installed."
    else
      echo -b "Installing ${name} …"
      brew install "${package}"
    fi

  elif [ -n "${tap}" ]; then

    [ -z "${name}" ] && name=${tap}
    if array_contains_exactly "${brew_tap_list}" "${tap}"; then
      echo -g "${name} is already tapped."
    else
      echo -b "Tapping ${name} …"
      brew tap "${tap}" || echo -r "Error tapping ${name}."
    fi

  fi

}


install_brew_taps() {

  # Homebrew Taps
  local brew_tap_list

  if brew_tap_list=$(brew tap); then

    brew_install -t caskroom/cask              -n 'Caskroom'
    brew_install -t caskroom/versions          -n 'Caskroom Versions'

    brew_install -t homebrew/command-not-found -n 'Homebrew Command-Not-Found'
    brew_install -t homebrew/dupes             -n 'Homebrew Dupes'
    brew_install -t homebrew/head-only         -n 'Homebrew HEAD-Only'
    brew_install -t homebrew/versions          -n 'Homebrew Versions'
    brew_install -t homebrew/x11               -n 'Homebrew X11'

    brew_install -t reitermarkus/tap           -n 'Personal Tap'

  fi

}


upgrade_brew_formulae() {

  # Upgrade Hombrew Formulae
  if type brew &>/dev/null; then
    echo -b 'Upgrading existing Homebrew formulae …'
    brew update && brew upgrade
  fi

  brew linkapps &>/dev/null

}



install_brew_formulae() {

  upgrade_brew_formulae

  # Install Homebrew Formulae
  if local brew_packages=$(brew ls); then

    is_desktop && brew_install -p apcupsd -n 'APCUPSD'
    brew_install -p bash               -n 'Bourne-Again Shell'
    brew_install -p bash-completion    -n 'Bash Completion'
    brew_install -p dockutil           -n 'Dock Util'
    brew_install -p git                -n 'Git'
    brew_install -p node               -n 'Node Package Manager'
    brew_install -p fish               -n 'Fish Shell'
    brew_install -p mackup             -n 'Mackup'
    brew_install -p python             -n 'Python 2'; if type pip &>/dev/null;  then pip  install --upgrade pip setuptools; fi
    brew_install -p python3            -n 'Python 3'; if type pip3 &>/dev/null; then pip3 install --upgrade pip setuptools; fi
    brew_install -p terminal-notifier  -n 'Terminal Notifier'
    brew_install -p ruby               -n 'Ruby'

    # Unlink Apps
    brew unlinkapps \
      python \
      python3 \
      qt \
      terminal-notifier \
    &>/dev/null

  fi

}


fix_caskroom_permissions() {

  # Fix Caskroom Permissions
  if local brew_packages=$(brew ls); then

    # Create Caskroom and set Permissions
    sudo mkdir -p /opt/homebrew-cask/Caskroom
    sudo chown root:wheel /opt
    sudo chmod -R u=rwx,go=rx /opt
    sudo chown -R root:admin  /opt/homebrew-cask
    sudo chmod -R ug=rwx,o=rx /opt/homebrew-cask
    sudo chflags hidden /opt

    # Set Permissions for Library folders.
    sudo chown -R root:admin  /Library/LaunchAgents /Library/LaunchDaemons /Library/PreferencePanes /Library/QuickLook /Library/Screen\ Savers
    sudo chmod -R ug=rwx,o=rx /Library/LaunchAgents /Library/LaunchDaemons /Library/PreferencePanes /Library/QuickLook /Library/Screen\ Savers

  fi

}


install_brew_cask_apps() {

  fix_caskroom_permissions

  # Install Homebrew Casks
  if local brew_casks=$(brew cask ls); then

    brew uninstall --force brew-cask

    brew_install -c a-better-finder-rename
    brew_install -oc reitermarkus/tap/adobe-creative-cloud -n 'Creative Cloud'
    brew_install -c adobe-illustrator-cc-de
    is_desktop && brew_install -c adobe-indesign-cc-de
    brew_install -c adobe-photoshop-cc-de
    brew_install -oc boom
    brew_install -c calibre
    brew_install -c chromium
    brew_install -c cocoapods
    brew_install -c cyberduck
    brew_install -oc dropbox
    brew_install -c epub-services
    brew_install -c evernote
    brew_install -c fritzing
    brew_install -c functionflip
    brew_install -c hazel
    brew_install -c hex-fiend
    brew_install -c iconvert -d /Applications/iTach
    brew_install -c ihelp    -d /Applications/iTach
    brew_install -c ilearn   -d /Applications/iTach
    brew_install -c itest    -d /Applications/iTach
    brew_install -c insomniax
    brew_install -c java -n 'Java'
    brew_install -c kaleidoscope
    brew_install -c keka
    brew_install -c konica-minolta-bizhub-c220-c280-c360-driver -n 'Bizhub Driver'
    brew_install -oc launchbar
    brew_install -c launchrocket
    brew_install -c mou
    brew_install -c netspot
    brew_install -c prizmo
    brew_install -c pycharm
    brew_install -c qlmarkdown
    brew_install -c qlstephen
    brew_install -c rcdefaultapp
    brew_install -c save-hollywood
    is_desktop && brew_install -c simple-sync
    brew_install -c sshfs
    brew_install -c sigil
    brew_install -c skype
    brew_install -c svgcleaner
    brew_install -c textmate
    brew_install -c texshop
    brew_install -c transmission
    brew_install -c tower
    brew_install -c unicodechecker
    brew_install -c vlc-nightly
    brew_install -c wineskin-winery
    brew_install -c xquartz


    # Conversion Tools

    local converters_dir='/Applications/Converters.localized'
    mkdir -p "${converters_dir}/.localized"
    echo '"Converters" = "Konvertierungswerkzeuge";' > "${converters_dir}/.localized/de.strings"
    echo '"Converters" = "Conversion Tools";' > "${converters_dir}/.localized/en.strings"
    brew_install -c handbrake  -d "${converters_dir}"
    brew_install -c makemkv    -d "${converters_dir}"
    brew_install -c mkvtools   -d "${converters_dir}"
    brew_install -c xld        -d "${converters_dir}"
    brew_install -c xnconvert  -d "${converters_dir}"
    brew_install -c image2icon -d "${converters_dir}"
    brew_install -c imageoptim -d "${converters_dir}"

  fi

}


brew_cleanup() {

  # Homebrew Cleanup
  if type brew &>/dev/null; then

    echo -r 'Removing dead Homebrew symlinks …'
    brew prune

    echo -r 'Emptying Homebrew cache …'
    brew cleanup --force
    brew cask cleanup

    if brew_cache="$(brew --cache)"; then
      # :? makes sure that this doesn't expand to /* and delete the entire system
      rm -rfv "${brew_cache:?}/"* | xargs printf "Removing: %s\n"
    fi

  fi

  # Remove unneeded Caskroom files.
  local caskroom=/opt/homebrew-cask/Caskroom

  # Remove Adobe CC installers.
  rm -rfv "${caskroom}"/adobe-*-cc*/latest/*/ | xargs -0 printf 'Removing: %s\n'

  # Remove PKG installers.
  find "${caskroom}" -iname '*.pkg' -print0 | xargs -0 rm -rfv | xargs -0 printf 'Removing: %s\n'

  # Remove invisible files.
  find -E "${caskroom}" -iregex \
       '.*/(\.background|\.com\.apple\.timemachine\.supported|\.DS_Store|\.DocumentRevisions|\.fseventsd|\.VolumeIcon\.icns|\.TemporaryItems|\.Trash).*' \
        -print0 | xargs -0 rm -rfv | xargs -0 printf 'Removing: %s\n'

  # Remove empty directories, but leave “version” directories.
  find "${caskroom}" -depth 3 -empty -print0 | xargs -0 rm -rfv | xargs -0 printf 'Removing: %s\n'

}
