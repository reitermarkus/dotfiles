#!/bin/sh


# Install Xcode Command Line Tools

xcode-select --install 2>/dev/null


# Homebrew Installation Messages
echo_exists() {
  cecho "$1 already installed." $green
}

echo_install() {
  cecho "Installing $1 …" $blue
}

echo_error() {
  cecho "$1" $red
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
    if ! brew ls $1 &>/dev/null; then
      echo_install "$2"
      brew install $1
    else
      echo_exists "$2"
    fi
  }

  # Add Homebrew Taps
  brew_tap_if_missing 'beeftornado/rmtree'
  brew_tap_if_missing 'caskroom/cask'
  brew_tap_if_missing 'caskroom/versions'
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
        brew cask install "$package" --appdir=/Applications

        if [ "$3" == "--open" ]; then
	      until open -a "$name" -gj &>/dev/null; do
	    	  sleep 0.1
	    	done
        fi &
      fi

    }

    brew_cask_if_missing adobe-creative-cloud   'Creative Cloud' --open
    brew_cask_if_missing asepsis                'Asepsis'
    brew_cask_if_missing a-better-finder-rename 'A Better Finder Rename'
    brew_cask_if_missing boom                   'Boom' --open
    brew_cask_if_missing cocoapods              'Cocoapods'
    brew_cask_if_missing coda                   'Coda'
    brew_cask_if_missing dropbox                'Dropbox' --open
    brew_cask_if_missing hazel                  'Hazel'
    brew_cask_if_missing imageoptim             'ImageOptim'
    brew_cask_if_missing kaleidoscope           'Kaleidoscope'
    brew_cask_if_missing launchrocket           'Launchrocket'
    brew_cask_if_missing sigil                  'Sigil'
    brew_cask_if_missing transmission           'Transmission'
    brew_cask_if_missing tower                  'Tower'
    brew_cask_if_missing vlc-nightly            'VLC Media Player'
    brew_cask_if_missing vmware-fusion          'VMware Fusion'
    brew_cask_if_missing xquartz                'XQuartz'
    brew_cask_if_missing microsoft-office       'Microsoft Office' && if [ -f /opt/homebrew-cask/Caskroom/microsoft-office/latest/Office\ Installer.pkg ]; then rm /opt/homebrew-cask/Caskroom/microsoft-office/latest/Office\ Installer.pkg; fi

  fi

  cecho 'Upgrading Homebrew Packages …' $blue
  brew upgrade

  cecho 'Linking Homebrew Apps …' $blue
  brew linkapps

  cecho 'Removing Dead Homebrew Symlinks …' $blue
  brew prune

  cecho 'Emptying Homebrew Cache …' $blue
  brew cleanup
  brew-cask cleanup

  sudo chown $USER /usr/local/

fi
