#!/bin/sh

# .sh | Dotfiles Setup for Markus Reiter


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

echo_error() {
    cecho "$1" $red
}


# Run “sudo” keep-alive.

sudo -v
while true; do sudo -n true; sleep 60; kill -0 "$$" || exit; done 2>/dev/null &



# Login Message in Terminal

touch ~/.hushlogin



# Login Window

cecho 'Disabling Guest Account …' $blue
sudo defaults write /Library/Preferences/com.apple.loginwindow GuestEnabled -bool false



# Finder Appearance and Behaviour

cecho 'Showing Icons for Hard Drives, Servers, and Removable Media on the Desktop …' $blue
defaults write com.apple.finder ShowExternalHardDrivesOnDesktop -bool true

cecho 'Disabling the Warning when changing a Extension …' $blue
defaults write com.apple.finder FXEnableExtensionChangeWarning -bool false

cecho 'Disabling the Warning when emptying Trash …' $blue
defaults write com.apple.finder WarnOnEmptyTrash -bool false



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
/System/Library/Frameworks/CoreServices.framework/Frameworks/LaunchServices.framework/Support/lsregister -kill -r -domain local -domain system -domain user &



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

    if brew ls "$package" &>/dev/null; then
      echo_exists "$name"
    else
      echo_install "$name"
      brew install "$package" || echo_error "Error installing $name."
    fi
  }

  # Add Homebrew Taps
  brew_tap_if_missing 'beeftornado/rmtree'
  brew_tap_if_missing 'caskroom/cask'
  brew_tap_if_missing 'homebrew/dupes'
  brew_tap_if_missing 'homebrew/versions'
  brew_tap_if_missing 'homebrew/x11'

  # Install Packages
  brew_if_missing brew-cask   'Brew Caskroom'
  brew_if_missing brew-rmtree 'External Command “rmtree”'
  brew_if_missing git         'Git'
  brew_if_missing npm         'Node Package Manager'
  brew_if_missing fish        'Fish Shell'
  brew_if_missing mackup      'Mackup'


  if hash brew-cask; then

    brew_cask_if_missing() {
      package=$1
      name=$2

      if brew cask ls "$package" &>/dev/null; then
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

    brew_cask_if_missing asepsis              'Asepsis'
    brew_cask_if_missing xquartz              'XQuartz'
    brew_cask_if_missing cocoapods            'Cocoapods'
    brew_cask_if_missing launchrocket         'Launchrocket'
    brew_cask_if_missing dropbox              'Dropbox'        --open
    brew_cask_if_missing adobe-creative-cloud 'Creative Cloud' --open
    brew_cask_if_missing sigil                'Sigil'
    brew_cask_if_missing vmware-fusion        'VMware Fusion'
    brew_cask_if_missing microsoft-office     'Microsoft Office'

  fi

  cecho 'Upgrading Homebrew Packages …' $blue
  brew upgrade || cecho 'Error Upgrading Homebrew Packages.' $red

  cecho 'Linking Homebrew Apps …' $blue
  brew linkapps || cecho 'Error Linking Homebrew Packages.' $red

  cecho 'Removing Dead Homebrew Symlinks …' $blue
  brew prune || cecho 'Error Removing Dead Homebrew Symlinks.' $red

  cecho 'Emptying Homebrew Cache …' $blue
  brew cleanup || cecho 'Error Emptying Homebrew Cache.' $red
  brew-cask cleanup || cecho 'Error Emptying Homebrew Cache.' $red

  sudo chown $USER /usr/local/

fi



# Change shell to “fish”.

if hash fish; then

  if ! cat /etc/shells | grep `which fish` &>/dev/null; then
    echo `which fish` | sudo tee -a /etc/shells > /dev/null
  fi

  if [[ ! "$SHELL" == *"/fish" ]]; then
    chsh -s `which fish`
  fi

fi

mkdir -p ~/.config/fish/


# Relocate Microsoft folder.

if [ -d ~/Documents/Microsoft*/ ]; then

  cecho 'Moving Microsoft folder to Library …' $blue
  mv ~/Documents/Microsoft*/ ~/Library/Preferences/

fi



# Create Symlinks for Dropbox folders.

link_to_dropbox() {

  user_dir='~'
  dropbox_dir=Dropbox

  if [[ -z $2 ]]; then
    dropbox_dir="$dropbox_dir/$1"
    local_dir="$1"
  else
    dropbox_dir="$dropbox_dir/$1"
    local_dir="$2"
  fi

  dropbox_dir="~/$dropbox_dir"
  local_dir="~/$local_dir"

  eval dropbox_dir_full=$dropbox_dir
  eval local_dir_full=$local_dir

  mkdir -p "$dropbox_dir_full"; mkdir -p "$local_dir_full"

  if [[ -L "$dropbox_dir_full" ]]; then
    cecho "$local_dir already linked to Dropbox." $green
  else
    cecho "Linking $local_dir to $dropbox_dir …" $blue
    cp -rf "$dropbox_dir_full"/* "$local_dir_full" && rm -rf "$dropbox_dir_full" && ln -sfn "$local_dir_full" "$dropbox_dir_full"
  fi

}

link_to_dropbox 'Desktop'

link_to_dropbox 'Documents/Backups'
link_to_dropbox 'Documents/Cinquecento'
link_to_dropbox 'Documents/Entwicklung'
link_to_dropbox 'Documents/Fonts'
link_to_dropbox 'Documents/Notizen'
link_to_dropbox 'Documents/Projekte'
link_to_dropbox 'Documents/Scans'
link_to_dropbox 'Documents/SketchUp'
link_to_dropbox 'Documents/Sonstiges'

link_to_dropbox 'Library/Fonts'

if hash mackup; then
  yes | mackup restore && \
  yes | mackup backup
fi
