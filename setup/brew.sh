#!/bin/sh


# Install Homebrew

if hash brew; then
  cecho 'Homebrew is already installed.' $green
else
  cecho 'Installing Homebrew …' $blue
  ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
fi


brew_install() {

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
      cecho "${name} is already installed." $green
    else
      cecho "Installing ${name} …" $blue

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
      cecho "${name} is already installed." $green
    else
      cecho "Installing ${name} …" $blue
      brew install "${package}"
    fi

  elif [ -n "${tap}" ]; then

    [ -z "${name}" ] && name=${tap}
    if array_contains_exactly "${taps}" "${tap}"; then
      cecho "${name} is already tapped." $green
    else
      cecho "Tapping ${name} …" $blue
      brew tap "${tap}" || cecho "Error tapping ${name}." $red
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

  brew_install -t reitermarkus/tap   -n 'Personal Tap'

  brew_install -t caskroom/cask      -n 'Caskroom'
  brew_install -t caskroom/versions  -n 'Caskroom Versions'

  brew_install -t homebrew/dupes     -n 'Homebrew Dupes'
  brew_install -t homebrew/head-only -n 'Homebrew HEAD-Only'
  brew_install -t homebrew/versions  -n 'Homebrew Versions'
  brew_install -t homebrew/x11       -n 'Homebrew X11'


  # Homebrew Packages

  brew_install -p brew-cask          -n 'Brew Caskroom'
  brew_install -p dockutil           -n 'Dock Util'
  brew_install -p git                -n 'Git'
  brew_install -p node               -n 'Node Package Manager'
  brew_install -p fish               -n 'Fish Shell'
  brew_install -p mackup             -n 'Mackup'
  brew_install -p terminal-notifier  -n 'Terminal Notifier'
  brew_install -p ruby               -n 'Ruby'


  if hash brew-cask; then


    # Homebrew Casks

    brew_install -c adobe-illustrator-cc-de
    [[ $is_mobile ]] || brew_install -c adobe-indesign-cc-de
    brew_install -c adobe-photoshop-cc-de
    brew_install -c a-better-finder-rename
    brew_install -oc boom
    brew_install -c calibre
    brew_install -c cocoapods
    brew_install -c cyberduck
    brew_install -oc dropbox
    brew_install -c epub-services
    brew_install -c evernote
    brew_install -c fritzing
    brew_install -c google-chrome
    brew_install -c hazel
    brew_install -c iconvert -  d /Applications/iTach
    brew_install -c ihelp      -d /Applications/iTach
    brew_install -c ilearn     -d /Applications/iTach
    brew_install -c itest      -d /Applications/iTach
    brew_install -c insomniax
    brew_install -c java       -n 'Java'
    brew_install -c kaleidoscope
    brew_install -c konica-minolta-bizhub-c220-c280-c360-driver -n 'Bizhub Driver'
    brew_install -oc launchbar
    osascript -e 'tell application "System Events" to make login item with properties {path:"'`mdfind -onlyin / kMDItemCFBundleIdentifier==at.obdev.LaunchBar`'", hidden:true}' -e 'return'
    brew_install -c launchrocket
    [[ $is_mobile ]] && brew_install -p netspot
    brew_install -c prizmo
    brew_install -c sigil
    brew_install -c skype
    brew_install -c svgcleaner
    brew_install -c textmate
    brew_install -c transmission
    # brew_install -c tower
    brew_install -c vlc-nightly
    brew_install -c wineskin-winery
    brew_install -c xquartz
    # brew_install -c microsoft-office-365 && mso_installer='/opt/homebrew-cask/Caskroom/microsoft-office365/latest/Microsoft_Office_2016_Installer.pkg' && if [ -f $mso_installer ]; then rm $mso_installer; fi

    # Conversion Tools
    converters_dir=/Applications/Converters.localized
    mkdir -p $converters_dir/.localized
    echo '"Converters" = "Konvertierungswerkzeuge";' > $converters_dir/.localized/de.strings
    echo '"Converters" = "Conversion Tools";' > $converters_dir/.localized/en.strings
    brew_install -c handbrake  -d $converters_dir
    brew_install -c makemkv    -d $converters_dir
    brew_install -c mkvtools   -d $converters_dir
    brew_install -c xld        -d $converters_dir
    brew_install -c xnconvert  -d $converters_dir
    brew_install -c image2icon -d $converters_dir
    brew_install -c imageoptim -d $converters_dir


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
