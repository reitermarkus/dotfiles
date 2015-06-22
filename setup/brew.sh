#!/bin/sh


# Install Xcode Command Line Tools
xcode-select --install


# Homebrew Installation Messages
echo_exists() {
  cecho "$1 already installed." $green
  return
}

echo_install() {
  cecho "Installing $1 …" $blue
  return
}

echo_error() {
  cecho $1 $red
  return
}


# Install Homebrew

if hash brew; then
  echo_exists 'Homebrew'
else
  echo_install 'Homebrew'
  ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
fi

if hash brew; then

  cecho 'Updating Homebrew …' $blue
  brew update

  brew_tap_if_missing() {
    if [[ "$1" == "`brew tap | grep $1`" ]]; then
      cecho "“$1” already tapped." $green
    else
      cecho "Tapping “$1” …" $blue
      brew tap "$1" || echo_error "Error tapping $1."
    fi
  }

  brew_if_missing() {
    package=$1
    name=$2

    if brew ls $package &>/dev/null; then
      echo_exists "$name"
    else
      echo_install "$name"
      brew install $package || echo_error "Error installing $name."
    fi
  }

  # Add Homebrew Taps
  brew_tap_if_missing 'beeftornado/rmtree'
  brew_tap_if_missing 'caskroom/cask'
  brew_tap_if_missing 'homebrew/head-only'
  brew_tap_if_missing 'homebrew/dupes'
  brew_tap_if_missing 'homebrew/versions'
  brew_tap_if_missing 'homebrew/x11'

  # Install Packages
  brew_if_missing brew-cask         'Brew Caskroom'
  brew_if_missing brew-rmtree       'External Command “rmtree”'
  brew_if_missing git               'Git'
  brew_if_missing npm               'Node Package Manager'
  brew_if_missing fish              'Fish Shell'
  brew_if_missing mackup            'Mackup'
  brew_if_missing terminal-notifier 'Terminal Notifier'


  if hash brew-cask; then

    brew_cask_if_missing() {
      package=$1
      name=$2

      if brew cask ls $package &>/dev/null; then
        echo_exists "$name"
      else
        echo_install "$name"
        brew cask install "$package" --appdir=/Applications || echo_error "Error installing $name."
      fi

      if [ "$3" == "--open" ]; then
	    until open -a "$name" -gj &>/dev/null; do
		  sleep 0.1
		done
      fi &

    }

    brew_cask_if_missing dropbox              'Dropbox'        --open
    brew_cask_if_missing adobe-creative-cloud 'Creative Cloud' --open
    brew_cask_if_missing asepsis              'Asepsis'
    brew_cask_if_missing cocoapods            'Cocoapods'
    brew_cask_if_missing coda                 'Coda'
    brew_cask_if_missing kaleidoscope         'Kaleidoscope'
    brew_cask_if_missing launchrocket         'Launchrocket'
    brew_cask_if_missing microsoft-office     'Microsoft Office'
    brew_cask_if_missing sigil                'Sigil'
    brew_cask_if_missing transmission         'Transmission'
    brew_cask_if_missing tower                'Tower'
    brew_cask_if_missing vmware-fusion        'VMware Fusion'
    brew_cask_if_missing xquartz              'XQuartz'

  fi

  cecho 'Upgrading Homebrew Packages …' $blue
  brew upgrade || echo_error 'Error Upgrading Homebrew Packages.'

  cecho 'Linking Homebrew Apps …' $blue
  brew linkapps || echo_error 'Error Linking Homebrew Packages.'

  cecho 'Removing Dead Homebrew Symlinks …' $blue
  brew prune || echo_error 'Error Removing Dead Homebrew Symlinks.'

  cecho 'Emptying Homebrew Cache …' $blue
  brew cleanup || echo_error 'Error Emptying Homebrew Cache.'
  brew-cask cleanup || echo_error 'Error Emptying Homebrew Cache.'

  sudo chown $USER /usr/local/

fi
