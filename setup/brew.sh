#!/bin/sh


# Install Homebrew

if hash brew; then
  echo_exists 'Homebrew'
else
  echo_install 'Homebrew'
  ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
fi

if hash brew; then

  taps=$(brew tap &)
  brews=$(brew ls &)
  casks=$(brew-cask ls &)

  cecho 'Updating Homebrew …' $blue
  brew update

  brew_tap_if_missing() {
    if printf -- '%s\n' "${taps[@]}" | grep "^$1$" &>/dev/null; then
      cecho "“$1” already tapped." $green
    else
      cecho "Tapping “$1” …" $blue
      brew tap "$1" || echo_error "Error tapping $1."
    fi
  }

  brew_if_missing() {
    if printf -- '%s\n' "${brews[@]}" | grep "^$1$" &>/dev/null; then
      echo_exists "$2"
    else
      echo_install "$2"
      brew install $1
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
  brew_if_missing dockutil          'Dock Util'
  brew_if_missing git               'Git'
  brew_if_missing node              'Node Package Manager'
  brew_if_missing fish              'Fish Shell'
  brew_if_missing mackup            'Mackup'
  brew_if_missing terminal-notifier 'Terminal Notifier'
  brew_if_missing ruby              'Ruby'

  if hash brew-cask; then
    
    brew_cask_if_missing() {
    
      appdir=/Applications
      name=''
      open=0

      local OPTIND
      while getopts ":p:n:od:" o; do
        case "${o}" in
          p) package="${OPTARG}";;
          n) name="${OPTARG}";;
          o) open=1;;
          d) appdir="${OPTARG}";;
        esac
      done
      shift $((OPTIND-1))
      
      info=$(brew-cask abv $package)
      
      if [ "$name" == '' ]; then
        if printf -- '%s\n' "${info[@]}" | grep '.app (app)' &>/dev/null; then
          name=$(printf -- '%s\n' "${info[@]}" | grep '.app (app)' | sed -E 's/^\ \ (.*)\.app.*$/\1/g' | sed -E 's/.*\///')
        else
          name=$(printf -- '%s\n' "${info[@]}" | head -2 | tail -1)
        fi
      fi
      
      if printf -- '%s\n' "${casks[@]}" | grep "^$package$" &>/dev/null; then
        echo_exists "$name"
      else
        echo_install "${name}"
        mkdir -p "$appdir"
        brew-cask install $package --appdir="$appdir" --force
      
        if [ ! -z "$name" ] && [ "$open" == 1 ]; then
          sleep 1
          until open -a "$name" -gj &>/dev/null; do
            sleep 0.1
          done
        fi
      fi
    }

    # Install Casks
    brew_cask_if_missing -op adobe-creative-cloud -n Creative\ Cloud
    brew_cask_if_missing -p adobe-illustrator-cc
    [[ $is_mobile ]] || brew_cask_if_missing -p adobe-indesign-cc
    brew_cask_if_missing -p adobe-photoshop-cc
    brew_cask_if_missing -p a-better-finder-rename
    brew_cask_if_missing -op boom
    brew_cask_if_missing -p calibre
    brew_cask_if_missing -p cocoapods
    brew_cask_if_missing -p cyberduck                
    brew_cask_if_missing -op dropbox
    brew_cask_if_missing -p evernote
    brew_cask_if_missing -p fritzing
    brew_cask_if_missing -p google-chrome
    brew_cask_if_missing -p hazel
    brew_cask_if_missing -p iconvert -d /Applications/iTach
    brew_cask_if_missing -p ihelp -d /Applications/iTach
    brew_cask_if_missing -p ilearn -d /Applications/iTach
    brew_cask_if_missing -p insomniax
    brew_cask_if_missing -p itest -d /Applications/iTach
    brew_cask_if_missing -p java
    brew_cask_if_missing -p kaleidoscope
    brew_cask_if_missing -p konica-minolta-bizhub-c220-c280-c360
    brew_cask_if_missing -op launchbar
    brew_cask_if_missing -p launchrocket
    [[ $is_mobile ]] && brew_cask_if_missing -p netspot
    brew_cask_if_missing -p prizmo
    brew_cask_if_missing -p sigil
    brew_cask_if_missing -p skype
    brew_cask_if_missing -p svgcleaner
    brew_cask_if_missing -p textmate
    brew_cask_if_missing -p transmission
    brew_cask_if_missing -p tower
    brew_cask_if_missing -p vlc-nightly
    brew_cask_if_missing -p wineskin-winery
    brew_cask_if_missing -p xquartz
    # brew_cask_if_missing -p microsoft-office-365 && mso_installer='/opt/homebrew-cask/Caskroom/microsoft-office365/latest/Microsoft_Office_2016_Installer.pkg' && if [ -f $mso_installer ]; then rm $mso_installer; fi
    
    # Conversion Tools
    converters_dir=/Applications/Converters.localized
    mkdir -p $converters_dir/.localized
    echo '"Converters" = "Konvertierungswerkzeuge";' > $converters_dir/.localized/de.strings
    echo '"Converters" = "Conversion Tools";' > $converters_dir/.localized/en.strings
    brew_cask_if_missing -p handbrake -d $converters_dir
    brew_cask_if_missing -p makemkv -d $converters_dir
    brew_cask_if_missing -p mkvtools -d $converters_dir
    brew_cask_if_missing -p xld -d $converters_dir
    brew_cask_if_missing -p xnconvert -d $converters_dir
    brew_cask_if_missing -p image2icon -d $converters_dir
    brew_cask_if_missing -p imageoptim -d $converters_dir
    
    
    # Depends on Java.
    brew_if_missing duck 'Cyberduck CLI'

  fi

  cecho 'Upgrading Homebrew Packages …' $blue
  brew upgrade

  cecho 'Linking Homebrew Apps …' $blue
  brew linkapps
  brew unlinkapps terminal-notifier

  cecho 'Removing Dead Homebrew Symlinks …' $blue
  brew prune

  cecho 'Emptying Homebrew Cache …' $blue
  brew cleanup
  brew-cask cleanup

  sudo chown $USER /usr/local/

fi
