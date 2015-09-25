#!/bin/sh


# Install Xcode Command Line Tools

xcode-select --install 2>/dev/null


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
  brew_tap_if_missing 'reitermarkus/tap'
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
  brew_if_missing ruby              'Ruby'


  if hash brew-cask; then
    
    brew_cask_if_missing() {
      _usage() { echo "Usage: brew_cask_if_missing -p <packages> [-n <name>] [-o]" 1>&2; exit; }
    
      appdir=/Applications
      name=''
      open=0

      local OPTIND
      while getopts ":p:n:oa:" o; do
        case "${o}" in
          p) package="${OPTARG}";;
          n) name="${OPTARG}";;
          o) open=1;;
          a) appdir="${OPTARG}";;
          *) _usage;;
        esac
      done
      shift $((OPTIND-1))
      
      if [ "$name" == '' ]; then
        name=$(brew cask abv $package | head -2 | tail -1)
      
        if brew cask abv $package | grep '.app (app)' &>/dev/null; then
          name=$(brew cask abv $package | grep '.app (app)' | sed -E 's/^\ \ (.*)\.app.*$/\1/g' | sed -E 's/.*\///')
        fi
      fi
      
      if brew cask ls $package &>/dev/null; then
        echo_exists "$name"
      else
        echo_install "${name}"
        mkdir -p "$appdir"
        brew cask install $package --appdir="$appdir" --force
      
        if [ ! -z "$name" ] && [ "$open" == 1 ]; then
          sleep 1
          until open -a "$name" -gj &>/dev/null; do
            sleep 0.1
          done
        fi
      fi
    }

    brew_cask_if_missing -op adobe-creative-cloud -n 'Creative Cloud'
    brew_cask_if_missing -p a-better-finder-rename      
    brew_cask_if_missing -op boom
    brew_cask_if_missing -p cocoapods           
    brew_cask_if_missing -p cyberduck                
    brew_cask_if_missing -op dropbox
    brew_cask_if_missing -p hazel                      
    brew_cask_if_missing -p imageoptim                   
    brew_cask_if_missing -p 'iconvert ihelp ilearn itest' -n 'Global Caché Test Suite' -a /Applications/iTach
    brew_cask_if_missing -p java                 
    brew_cask_if_missing -p kaleidoscope             
    brew_cask_if_missing -p launchrocket           
    brew_cask_if_missing -p sigil                       
    brew_cask_if_missing -p textmate                     
    brew_cask_if_missing -p transmission              
    brew_cask_if_missing -p tower                     
    brew_cask_if_missing -p vlc-nightly                
    brew_cask_if_missing -p xquartz                    
    brew_cask_if_missing -p microsoft-office \
      && if [ -f /opt/homebrew-cask/Caskroom/microsoft-office/latest/Office\ Installer.pkg ]; then
           rm /opt/homebrew-cask/Caskroom/microsoft-office/latest/Office\ Installer.pkg
         fi
    
    # Depends on Java.
    brew_if_missing duck 'Cyberduck CLI'

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
