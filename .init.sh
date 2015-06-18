#!/bin/sh



# Set the colours you can use

black='\033[0;30m'
white='\033[0;37m'
red='\033[0;31m'
green='\033[0;32m'
yellow='\033[0;33m'
blue='\033[0;34m'
magenta='\033[0;35m'
cyan='\033[0;36m'



# Resets the style

reset=`tput sgr0`



# Colored “echo”
# Usage: cecho message color

cecho() {
  echo "${2}${1}${reset}"
  return
}

echo_exists() {
	cecho "$1 already installed." $green
}

echo_install() {
	cecho "Installing $1 …" $blue
}



# Run “sudo” keep-alive.

sudo -v
while true; do sudo -n true; sleep 60; kill -0 "$$" || exit; done 2>/dev/null &



# Login Window

cecho 'Disabling Guest Account …' $blue
sudo defaults write /Library/Preferences/com.apple.loginwindow GuestEnabled -bool false



# Finder Appearance and Behaviour

cecho 'Showing Icons for Hard Drives, Servers, and Removable Media on the Desktop …' $blue
defaults write com.apple.finder ShowExternalHardDrivesOnDesktop -bool true

cecho 'Disabling the Warning when changing a Extension …' $blue
defaults write com.apple.finder FXEnableExtensionChangeWarning -bool false



# Dock & Mission Control

cecho 'Increasing Mission Control Animation Speed …' $blue
defaults write com.apple.dock expose-animation-duration -float 0.125

cecho 'Hiding Dock automatically …' $blue
defaults write com.apple.dock autohide -bool true



# Safari

cecho "Changing Safari's In-Page Search to “contains” instead of “starts with” …" $blue
defaults write com.apple.Safari FindOnPageMatchesWordStartsOnly -bool false



# General User Interface

cecho 'Expanding the Save Panel by Default …' $blue
defaults write NSGlobalDomain NSNavPanelExpandedStateForSaveMode -bool true
defaults write NSGlobalDomain PMPrintingExpandedStateForPrint    -bool true
defaults write NSGlobalDomain PMPrintingExpandedStateForPrint2   -bool true

cecho 'Removing Duplicates in “Open With” Menu …' $blue
/System/Library/Frameworks/CoreServices.framework/Frameworks/LaunchServices.framework/Support/lsregister -kill -r -domain local -domain system -domain user



# Install Homebrew

if hash brew; then
  echo_exists 'Homebrew'
else
  echo_install 'Homebrew'
  ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)" &>/dev/null
fi


if hash brew; then

  cecho 'Updating Homebrew …' $blue
  brew update &>/dev/null
  
  brew_tap_if_missing() {
    if brew tap "$1" &>/dev/null; then
      cecho "“$1” already tapped." $green
    else
      cecho "Tapping “$1” …" $blue
      brew tap 'homebrew/dupes'
    fi
  }
  
  brew_tap_if_missing 'beeftornado/rmtree'
  brew_tap_if_missing 'caskroom/cask'
  brew_tap_if_missing 'homebrew/dupes'
  brew_tap_if_missing 'homebrew/versions'
  brew_tap_if_missing 'homebrew/x11'

  brew_if_missing() {
    package=$1
    name=$2
    
    if brew ls "$package" &>/dev/null; then
      echo_exists "$name"
    else
      echo_install "$name"
      brew install "$package"
    fi
    
  }

  brew_if_missing git         'Git'
  brew_if_missing npm         'Node Package Manager'
  brew_if_missing fish        'Fish Shell'
  brew_if_missing brew-cask   'Brew Caskroom'
  brew_if_missing brew-rmtree 'External Command “rmtree”'
  

  if hash brew-cask
  then
	  
	can_be_opened() {
      open -gj "$1" &>/dev/null
	}
  	
    # Install Dropbox.
    if can_be_opened '/Applications/Dropbox.app'; then
      echo_exists 'Dropbox'
    else
      echo_install 'Dropbox'
      brew-cask install dropbox --force --appdir=/Applications
    fi

    # Install Creative Cloud.
    if can_be_opened '/Applications/Utilities/Adobe Creative Cloud/ACC/Creative Cloud.app'; then
      echo_exists 'Adobe Creative Cloud'
    else
      echo_install 'Adobe Creative Cloud'
      brew-cask install  adobe-creative-cloud --force | grep '.app' | xargs open
    fi

    # Install Sigil.
    if [ -d '/Applications/Sigil.app' ]; then
      echo_exists 'Sigil'
    else
      echo_install 'Sigil'
      brew-cask install  sigil --force --appdir=/Applications
    fi
  
  fi
  
  cecho 'Upgrading Homebrew Packages …' $blue
  brew upgrade &>/dev/null

  cecho 'Linking Apps …' $blue
  brew linkapps &>/dev/null

  cecho 'Removing Dead Symlinks …' $blue
  brew prune &>/dev/null

  cecho 'Removing Cached Downloads …' $blue
  brew cleanup &>/dev/null
  brew-cask cleanup &>/dev/null
  
  sudo chown $USER /usr/local/

fi



# Change shell to “fish”.

if hash fish
then
  if ! cat /etc/shells | grep '/fish' &>/dev/null
  then
    echo `which fish` | sudo tee -a /etc/shells > /dev/null
  fi
  if [[ ! "$SHELL" == *"/fish" ]]
  then
    chsh -s `which fish`
  fi
fi