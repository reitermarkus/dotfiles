#!/bin/sh


# Install Homebrew

install_brew() {

  sudo chown "${USER}" /usr/local/

  if hash brew; then
    echo -g 'Homebrew is already installed.'
  else
    echo -b 'Installing Homebrew …'
    ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
  fi

  if hash brew; then
    echo -b 'Updating Homebrew Packages …'
    brew update && brew upgrade
  fi

}


# Hombrew Install Function

brew_install() {

  local cask
  local name
  local package
  local tap
  local appdir
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

    [ -z "${appdir}" ] && appdir=/Applications/

    local info=$(brew-cask info "${cask}")

    if [ -z "${name}" ]; then
      if array_contains "${info}" '.app (app)'; then
        name=$(printf '%s\n' "${info[@]}" | grep '.app (app)' | sed -E 's/^\ \ (.*)\.app.*$/\1/g' | sed -E 's/.*\///')
      else
        name=$(printf '%s\n' "${info[@]}" | head -2 | tail -1)
      fi
    fi

    if array_contains_exactly "${brew_casks}" "$(basename ${cask})"; then
      echo -g "${name} is already installed."
    else
      echo -b "Installing ${name} …"

      mkdir -p "${appdir}"
      sudo brew-cask uninstall "${cask}" --force
      sudo brew-cask install "${cask}" --force \
        --appdir="${appdir}" \
        --prefpanedir=/Library/PreferencePanes \
        --qlplugindir=/Library/QuickLook \
        --screen_saverdir=/Library/Screen\ Savers

      if [ "${open}" == true ] && [ -n "${name}" ]; then
        local timeout=15
        let timeout*=10
        until open -jga "${name}" &>/dev/null || [ "${timeout}" -lt 0 ]; do
          let timeout--
          sleep 0.1
        done &
      fi
    fi

  elif [ -n "${package}" ]; then

    [ -z "${name}" ] && name=${package}
    if array_contains_exactly "${brew_packages}" "$(basename ${package})"; then
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


# Install Homebrew Taps

install_brew_taps() {

  local brew_tap_list

  if brew_tap_list=$(brew tap); then

    brew_install -t reitermarkus/tap   -n 'Personal Tap'

    brew_install -t caskroom/cask      -n 'Caskroom'
    brew_install -t caskroom/versions  -n 'Caskroom Versions'

    brew_install -t homebrew/dupes     -n 'Homebrew Dupes'
    brew_install -t homebrew/head-only -n 'Homebrew HEAD-Only'
    brew_install -t homebrew/versions  -n 'Homebrew Versions'
    brew_install -t homebrew/x11       -n 'Homebrew X11'

  fi
}


# Homebrew Packages

install_brew_packages() {

  local brew_packages

  if brew_packages=$(brew ls); then

    brew_install -p bash               -n 'Bourne-Again Shell'
    brew_install -p bash-completion    -n 'Bash Completion'
    brew_install -p dockutil           -n 'Dock Util'
    brew_install -p git                -n 'Git'
    brew_install -p node               -n 'Node Package Manager'
    brew_install -p fish               -n 'Fish Shell'
    brew_install -p mackup             -n 'Mackup'
    brew_install -p terminal-notifier  -n 'Terminal Notifier'
    brew_install -p ruby               -n 'Ruby'

  fi
}


# Homebrew Cask

install_brew_cask() {

  local brew_packages

  if brew_packages=$(brew ls); then

    brew_install -p brew-cask          -n 'Brew Caskroom'

    sudo mkdir -p /opt/homebrew-cask/Caskroom
    sudo chown -R ${USER}:staff /opt/homebrew-cask
    sudo chflags hidden /opt

  fi
}


# Homebrew Casks

install_brew_cask_apps() {

  local brew_casks

  if brew_casks=$(brew-cask ls); then

    brew_install -oc reitermarkus/tap/adobe-creative-cloud -n 'Creative Cloud'
    brew_install -c adobe-illustrator-cc-de
    is_desktop && brew_install -c adobe-indesign-cc-de
    brew_install -c adobe-photoshop-cc-de
    brew_install -c a-better-finder-rename
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
    brew_install -c iconvert -  d /Applications/iTach
    brew_install -c ihelp      -d /Applications/iTach
    brew_install -c ilearn     -d /Applications/iTach
    brew_install -c itest      -d /Applications/iTach
    brew_install -c insomniax
    brew_install -c java       -n 'Java'
    brew_install -c kaleidoscope
    brew_install -c konica-minolta-bizhub-c220-c280-c360-driver -n 'Bizhub Driver'
    brew_install -oc launchbar
      osascript -e 'tell application "System Events" to make login item with properties {path:"'$(mdfind -onlyin / kMDItemCFBundleIdentifier==at.obdev.LaunchBar)'", hidden:true}' -e 'return'
    brew_install -c launchrocket
    brew_install -c mou
    brew_install -c netspot
    brew_install -c prizmo
    brew_install -c sigil
    brew_install -c skype
    brew_install -c svgcleaner
    brew_install -c textmate
    brew_install -c texshop
    brew_install -c transmission
    brew_install -c tower
    brew_install -c vlc-nightly
    brew_install -c wineskin-winery
    brew_install -c xquartz


    # Conversion Tools

    converters_dir='/Applications/Converters.localized'
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
}


# Homebrew Cleanup

brew_cleanup() {

  if hash brew; then

    brew linkapps &>/dev/null
    brew unlinkapps terminal-notifier &>/dev/null

    echo -r 'Removing Dead Homebrew Symlinks …'
    brew prune

    echo -r 'Emptying Homebrew Cache …'
    brew cleanup --force
    brew-cask cleanup
    rm -rfv "$(brew --cache)/*" | xargs printf "Removing: %s\n"

  fi
}
