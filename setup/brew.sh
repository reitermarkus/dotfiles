#!/bin/sh


# Install Homebrew

if hash brew; then
  echo_exists 'Homebrew'
else
  echo_install 'Homebrew'
  ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
fi


brew_pour() {

  local cask
  local name
  local package
  local tap
  local open=false

  local OPTIND
  while getopts ":c:d:p:t:n:o" o; do
    case "${o}" in
      n)    name="${OPTARG}";;
      c)    cask="${OPTARG}";;
      d)  appdir="${OPTARG}";;
      p) package="${OPTARG}";;
      t)     tap="${OPTARG}";;
      o)    open=true;;
    esac
  done
  shift $((OPTIND-1))

  if [ -n "${cask}" ]; then

    [ -z "${appdir}" ] && appdir='/Applications'

    local info=$(brew-cask info "${cask}")

    if [ -z "${name}" ]; then
      if array_contains "${info}" '.app (app)'; then
        name=$(printf '%s\n' "${info[@]}" | grep '.app (app)' | sed -E 's/^\ \ (.*)\.app.*$/\1/g' | sed -E 's/.*\///')
      else
        name=$(printf '%s\n' "${info[@]}" | head -2 | tail -1)
      fi
    fi

    if array_contains_exactly "${casks}" "${cask}"; then
      echo_exists "${name}"
    else
      echo_install "${name}"

      mkdir -p "${appdir}"
      brew-cask uninstall "${cask}" --force
      brew-cask install "${cask}" --appdir="${appdir}" --force

      if [ -n "${name}" ] && [[ ${open} ]]; then
        local timeout = 10
        until open -a "${name}" -gj &>/dev/null || [ "${timeout}" -lt 0 ]; do
          let timeout=timeout-0.1
          sleep 0.1
        done &
      fi
    fi

  elif [ -n "${package}" ]; then

    [ -z "${name}" ] && name=${package}
    if array_contains_exactly "${brews}" "${package}"; then
      echo_exists "${name}"
    else
      echo_install "${name}"
      brew install "${package}"
    fi

  elif [ -n "${tap}" ]; then

    [ -z "${name}" ] && name=${tap}
    if array_contains_exactly "${taps}" "${tap}"; then
      cecho "${name} is already tapped." $green
    else
      cecho "Tapping ${name} …" $blue
      brew tap "${tap}" || echo_error "Error tapping ${name}."
    fi
  fi

}


if hash brew; then


  taps=$(brew tap &)
  brews=$(brew ls &)
  casks=$(brew-cask ls &)


  cecho 'Updating Homebrew …' $blue
  brew update


  # Homebrew Taps

  brew_pour -t reitermarkus/tap   -n 'Personal Tap'

  brew_pour -t caskroom/cask      -n 'Caskroom'
  brew_pour -t caskroom/versions  -n 'Caskroom Versions'

  brew_pour -t homebrew/dupes     -n 'Homebrew Dupes'
  brew_pour -t homebrew/head-only -n 'Homebrew HEAD-Only'
  brew_pour -t homebrew/versions  -n 'Homebrew Versions'
  brew_pour -t homebrew/x11       -n 'Homebrew X11'


  # Homebrew Packages

  brew_pour -p brew-cask          -n 'Brew Caskroom'
  brew_pour -p dockutil           -n 'Dock Util'
  brew_pour -p git                -n 'Git'
  brew_pour -p node               -n 'Node Package Manager'
  brew_pour -p fish               -n 'Fish Shell'
  brew_pour -p mackup             -n 'Mackup'
  brew_pour -p terminal-notifier  -n 'Terminal Notifier'
  brew_pour -p ruby               -n 'Ruby'


  if hash brew-cask; then


    # Homebrew Casks

    brew_pour -c adobe-illustrator-cc-de
    [[ $is_mobile ]] || brew_pour -c adobe-indesign-cc-de
    brew_pour -c adobe-photoshop-cc-de
    brew_pour -c a-better-finder-rename
    brew_pour -oc boom
    brew_pour -c calibre
    brew_pour -c cocoapods
    brew_pour -c cyberduck
    brew_pour -oc dropbox
    brew_pour -c epub-services
    brew_pour -c evernote
    brew_pour -c fritzing
    brew_pour -c google-chrome
    brew_pour -c hazel
    brew_pour -c iconvert -  d /Applications/iTach
    brew_pour -c ihelp      -d /Applications/iTach
    brew_pour -c ilearn     -d /Applications/iTach
    brew_pour -c itest      -d /Applications/iTach
    brew_pour -c insomniax
    brew_pour -c java       -n 'Java'
    brew_pour -c kaleidoscope
    brew_pour -c konica-minolta-bizhub-c220-c280-c360-driver -n 'Bizhub Driver'
    brew_pour -oc launchbar
    osascript -e 'tell application "System Events" to make login item with properties {path:"'`mdfind -onlyin / kMDItemCFBundleIdentifier==at.obdev.LaunchBar`'", hidden:true}' -e 'return'
    brew_pour -c launchrocket
    [[ $is_mobile ]] && brew_pour -p netspot
    brew_pour -c prizmo
    brew_pour -c sigil
    brew_pour -c skype
    brew_pour -c svgcleaner
    brew_pour -c textmate
    brew_pour -c transmission
    # brew_pour -c tower
    brew_pour -c vlc-nightly
    brew_pour -c wineskin-winery
    brew_pour -c xquartz
    # brew_pour -c microsoft-office-365 && mso_installer='/opt/homebrew-cask/Caskroom/microsoft-office365/latest/Microsoft_Office_2016_Installer.pkg' && if [ -f $mso_installer ]; then rm $mso_installer; fi

    # Conversion Tools
    converters_dir=/Applications/Converters.localized
    mkdir -p $converters_dir/.localized
    echo '"Converters" = "Konvertierungswerkzeuge";' > $converters_dir/.localized/de.strings
    echo '"Converters" = "Conversion Tools";' > $converters_dir/.localized/en.strings
    brew_pour -c handbrake  -d $converters_dir
    brew_pour -c makemkv    -d $converters_dir
    brew_pour -c mkvtools   -d $converters_dir
    brew_pour -c xld        -d $converters_dir
    brew_pour -c xnconvert  -d $converters_dir
    brew_pour -c image2icon -d $converters_dir
    brew_pour -c imageoptim -d $converters_dir


  fi


  cecho 'Upgrading Homebrew Packages …' $blue
  brew upgrade

  cecho 'Linking Homebrew Apps …' $blue
  brew linkapps
  brew unlinkapps terminal-notifier

  cecho 'Removing Dead Homebrew Symlinks …' $blue
  brew prune

  cecho 'Emptying Homebrew Cache …' $blue
  brew cleanup --force
  rm -rf "$(brew --cache)"
  brew-cask cleanup

  sudo chown $USER /usr/local/

fi
