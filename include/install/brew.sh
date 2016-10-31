install_brew() {

  if type brew &>/dev/null; then
    echo -g 'Homebrew is already installed.'
  else
    echo -b 'Installing Homebrew …'
    /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
  fi

  /bin/launchctl load ~/Library/LaunchAgents/sh.brew.updater.plist &>/dev/null

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
      OIFS=${IFS}
      IFS=';'
      for caskname in $(brew cask _stanza name "${cask}" | /usr/bin/sed 's/", "/\;/g' | tr -d '["]'); do
        name="${caskname}"
      done
      IFS=${OIFS}
    fi

    if array_contains_exactly "${brew_casks}" "$(/usr/bin/basename "${cask}")"; then
      echo -g "${name} is already installed."
    else
      echo -b "Installing ${name} …"

      /bin/mkdir  -p "${appdir}"
      brew cask uninstall "${cask}" --force &>/dev/null
      brew cask install "${cask}" --force \
        --appdir="${appdir}" \
        --dictionarydir=/Library/Dictionaries \
        --prefpanedir=/Library/PreferencePanes \
        --qlplugindir=/Library/QuickLook \
        --screen_saverdir=/Library/Screen\ Savers

      if [ "${open}" == true ]; then
        IFS=';'

        local apps=($(brew cask _stanza app "${cask}" | /usr/bin/sed 's/", "/\;/g' | tr -d '["]'))

        if [ -z "${apps[@]}" ]; then
          apps="${name}"
        fi

        for app in ${apps[*]}; do
          echo -b "Opening ${app} …"
          local timeout=15
          let timeout*=10
          until /usr/bin/open -jga "$(/usr/bin/sed 's/\.app\$//' <<< "${app}")" &>/dev/null || [ "${timeout}" -lt 0 ]; do
            let timeout--
            /bin/sleep 0.1
          done &
        done

        IFS=${OIFS}
      fi

    fi

  elif [ -n "${package}" ]; then

    [ -z "${name}" ] && name=${package}
    if array_contains_exactly "${brew_packages}" "$(/usr/bin/basename "${package}")"; then
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

    brew linkapps &>/dev/null
  fi

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
    brew_install -p mas                -n 'Mac App Store CLI'
    brew_install -p python             -n 'Python 2'; if type pip2 &>/dev/null; then pip2 install --upgrade pip setuptools; fi
    brew_install -p python3            -n 'Python 3'; if type pip3 &>/dev/null; then pip3 install --upgrade pip setuptools; fi
    brew_install -p ruby               -n 'Ruby'
    brew_install -p terminal-notifier  -n 'Terminal Notifier'
    brew_install -p trash              -n 'Trash'
    brew_install -p valgrind           -n 'Valgrind'

    echo -r 'Unlinking Homebrew apps …'
    brew unlinkapps \
      python \
      python3 \
      terminal-notifier \
    2>/dev/null

    echo -r 'Removing dead Homebrew symlinks …'
    brew prune

    echo -r 'Emptying Homebrew cache …'
    brew cleanup

  fi

}

install_brew_cask_apps() {

  # Create global Dictionaries directory.
  /usr/bin/sudo -E -- /bin/mkdir -p /Library/Dictionaries

  # Set Permissions for Library folders.
  /usr/bin/sudo -E -- /usr/sbin/chown root:admin  /Library/LaunchAgents /Library/LaunchDaemons /Library/Dictionaries /Library/PreferencePanes /Library/QuickLook /Library/Screen\ Savers
  /usr/bin/sudo -E -- /bin/chmod -R ug=rwx,o=rx /Library/LaunchAgents /Library/LaunchDaemons /Library/Dictionaries /Library/PreferencePanes /Library/QuickLook /Library/Screen\ Savers

  # Install Homebrew Casks
  if local brew_casks=$(brew cask ls); then

    brew uninstall --force brew-cask

    brew_install -c a-better-finder-rename                      -n 'A Better Finder Rename'
    brew_install -c adobe-creative-cloud                        -n 'Adobe Creative Cloud'
    brew_install -c adobe-illustrator-cc                        -n 'Adobe Illustrator CC'
    is_desktop && brew_install -c adobe-indesign-cc             -n 'Adobe InDesign CC'
    brew_install -c adobe-photoshop-cc                          -n 'Adobe Photoshop CC'
    brew_install -c arduino-nightly                             -n 'Arduino IDE'
    brew_install -oc boom                                       -n 'Boom'
    brew_install -c calibre                                     -n 'Calibre'
    brew_install -c chromium                                    -n 'Chromium'
    brew_install -c cyberduck                                   -n 'Cyberduck'
    brew_install -oc dropbox                                    -n 'Dropbox'
    brew_install -c epub-services                               -n 'EPUB Services'
    brew_install -c evernote                                    -n 'Evernote'
    brew_install -c fritzing                                    -n 'Fritzing'
    brew_install -c functionflip                                -n 'FunctionFlip'
    brew_install -c hazel                                       -n 'Hazel'
    brew_install -c hex-fiend                                   -n 'Hex Fiend'
    brew_install -c iconvert -d /Applications/iTach             -n 'iConvert'
    brew_install -c ihelp    -d /Applications/iTach             -n 'iHelp'
    brew_install -c ilearn   -d /Applications/iTach             -n 'iLearn'
    brew_install -c itest    -d /Applications/iTach             -n 'iTest'
    brew_install -c insomniax                                   -n 'InsomniaX'
    brew_install -c java                                        -n 'Java'
    brew_install -c kaleidoscope                                -n 'Kaleidoscope'
    brew_install -c keka                                        -n 'Keka'
    brew_install -c konica-minolta-bizhub-c220-c280-c360-driver -n 'Bizhub Driver'
    brew_install -oc launchbar                                  -n 'LaunchBar'
    brew_install -c launchrocket                                -n 'LaunchRocket'
    brew_install -c macdown                                     -n 'MacDown'
    brew_install -c netspot                                     -n 'NetSpot'
    brew_install -c prizmo                                      -n 'Prizmo'
    brew_install -c qlmarkdown                                  -n 'QLMarkDown'
    brew_install -c qlstephen                                   -n 'QLStephen'
    brew_install -c rcdefaultapp                                -n 'RCDefaultApp'
    brew_install -c save-hollywood                              -n 'SaveHollywood'
    brew_install -c sequel-pro                                  -n 'Sequel Pro'
    brew_install -c sigil                                       -n 'Sigil'
    is_desktop && brew_install -c simple-hub                    -n 'Simple Hub'
    brew_install -c skype                                       -n 'Skype'
    brew_install -c sqlitebrowser                               -n 'SqliteBrowser'
    brew_install -c sshfs                                       -n 'SSHFS'
    brew_install -c svgcleaner                                  -n 'SVGCleaner'
    brew_install -c telegram                                    -n 'Telegram'
    brew_install -c textmate                                    -n 'TextMate'
    brew_install -c texshop                                     -n 'TexShop'
    brew_install -c transmission                                -n 'Transmission'
    brew_install -c tower-beta                                  -n 'Tower'
    brew_install -c unicodechecker                              -n 'UnicodeChecker'
    brew_install -c vlc-nightly                                 -n 'VLC'
    brew_install -c wineskin-winery                             -n 'Wineskin Winery'
    brew_install -c xquartz                                     -n 'XQuartz'


    # Conversion Tools

    local converters_dir='/Applications/Converters.localized'
    /bin/mkdir  -p "${converters_dir}/.localized"
    echo '"Converters" = "Konvertierungswerkzeuge";' > "${converters_dir}/.localized/de.strings"
    echo '"Converters" = "Conversion Tools";' > "${converters_dir}/.localized/en.strings"
    brew_install -c handbrake  -d "${converters_dir}"
    brew_install -c makemkv    -d "${converters_dir}"
    brew_install -c mkvtools   -d "${converters_dir}"
    brew_install -c xld        -d "${converters_dir}"
    brew_install -c xnconvert  -d "${converters_dir}"
    brew_install -c image2icon -d "${converters_dir}"
    brew_install -c imageoptim -d "${converters_dir}"

    echo -r 'Emptying Homebrew Cask cache …'
    brew cask cleanup

  fi

}
