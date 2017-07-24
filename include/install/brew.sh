install_brew() {

  if which brew &>/dev/null; then
    echo -g 'Homebrew is already installed.'
  else
    echo -b 'Installing Homebrew …'
    with_askpass /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
  fi

}


# Hombrew Install Function

brew() {

  BREW_INSTALLED_TAPS="${BREW_INSTALLED_TAPS:-$(command brew tap 2>/dev/null)}"
  BREW_INSTALLED_CASKS="${BREW_INSTALLED_CASKS:-$(command brew cask list 2>/dev/null)}"
  BREW_INSTALLED_FORMULAE="${BREW_INSTALLED_FORMULAE:-$(command brew list 2>/dev/null)}"

  case "${1}" in
  tap)
    local tap="${2}"
    if array_contains_exactly "${BREW_INSTALLED_TAPS[@]}" "${tap}"; then
      echo -g "${tap} is already tapped."
    else
      echo -b "Tapping ${tap} …"
      command brew "${@}" || echo -r "Error tapping ${tap}."
    fi
    ;;
  cask)
    case "${2}" in
    install)
      local cask="${3}"

      if array_contains_exactly "${BREW_INSTALLED_CASKS[@]}" "${cask##*/}"; then
        echo -g "${cask} is already installed."
      else
        echo -b "Installing ${cask} …"
        with_askpass command brew "${@}" \
          --dictionarydir=/Library/Dictionaries \
          --prefpanedir=/Library/PreferencePanes \
          --qlplugindir=/Library/QuickLook \
          --screen_saverdir=/Library/Screen\ Savers
      fi
      ;;
    *)
      command brew "${@}"
      ;;
    esac
   ;;
  install)
    local formula="${2}"
    if array_contains_exactly "${BREW_INSTALLED_FORMULAE[@]}" "${formula##*/}"; then
      echo -g "${formula} is already installed."
    else
      echo -b "Installing ${formula} …"
      command brew "${@}"
    fi
    ;;
  *)
    command brew "${@}"
    ;;
  esac

}


install_brew_taps() {

  # Homebrew Taps

  brew tap caskroom/cask
  brew tap caskroom/drivers
  brew tap caskroom/fonts
  brew tap caskroom/versions

  brew tap homebrew/command-not-found
  brew tap homebrew/dupes
  brew tap homebrew/fuse
  brew tap homebrew/x11

  brew tap fisherman/tap

  brew tap reitermarkus/tap

}


install_brew_formulae() {

  # Upgrade Hombrew Formulae
  echo -b 'Updating Homebrew …'
  brew update --force

  # Install Homebrew Formulae

  is_desktop && brew install apcupsd
  brew install bash
  brew install bash-completion
  brew install crystal-lang
  brew install dockutil
  brew install git
  brew install git-lfs
  brew install ghc
  brew install iperf3
  brew install node
  brew install fish
  brew install fisherman
  brew install lockscreen
  brew install mackup
  brew install mas
  brew install ocaml
  brew install ocamlbuild
  brew install python3; if which pip3 &>/dev/null; then pip3 install --upgrade pip setuptools; fi
  brew install rlwrap
  brew install rbenv
  brew install rbenv-binstubs
  brew install rbenv-system-ruby
  brew cask install osxfuse && brew install sshfs
  brew install terminal-notifier
  brew install thefuck
  brew install trash
  brew install valgrind

}

install_brew_casks() {

  # Create global Dictionaries directory.
  sudo -E -- /bin/mkdir -p /Library/Dictionaries

  # Set Permissions for Library folders.
  sudo -E -- /usr/sbin/chown root:admin  /Library/LaunchAgents /Library/LaunchDaemons /Library/Dictionaries /Library/PreferencePanes /Library/QuickLook /Library/Screen\ Savers
  sudo -E -- /bin/chmod -R ug=rwx,o=rx /Library/LaunchAgents /Library/LaunchDaemons /Library/Dictionaries /Library/PreferencePanes /Library/QuickLook /Library/Screen\ Savers

  # Install Homebrew Casks

  brew cask install a-better-finder-rename
  brew cask install adobe-creative-cloud
  brew cask install adobe-illustrator-cc
  is_desktop && brew cask install adobe-indesign-cc
  brew cask install adobe-photoshop-cc
  brew cask install arduino-nightly
  brew cask install calibre
  brew cask install chromium
  brew cask install cyberduck
  brew cask install detexify
  brew cask install dropbox
  brew cask install docker
  brew cask install epub-services
  brew cask install evernote
  brew cask install fritzing
  brew cask install font-meslo-nerd-font
  brew cask install hazel
  brew cask install hex-fiend
  sudo -E -- /bin/mkdir -p /Applications/iTach
  brew cask install iconvert --appdir=/Applications/iTach
  brew cask install ihelp    --appdir=/Applications/iTach
  brew cask install ilearn   --appdir=/Applications/iTach
  brew cask install itest    --appdir=/Applications/iTach
  brew cask install insomniax
  brew cask install java
  brew cask install kaleidoscope
  brew cask install keka
  brew cask install konica-minolta-bizhub-c220-c280-c360-driver
  brew cask install launchrocket
  brew cask install macdown
  brew cask install mactex
  brew cask install netspot
  brew cask install playnow
  brew cask install prizmo
  brew cask install postman
  brew cask install qlmarkdown
  brew cask install qlstephen
  brew cask install rcdefaultapp
  brew cask install rocket
  brew cask install save-hollywood
  brew cask install sequel-pro
  brew cask install sigil
  brew cask install skype
  brew cask install slack
  brew cask install sqlitebrowser
  brew cask install svgcleaner
  brew cask install table-tool
  brew cask install telegram
  brew cask install textmate
  brew cask install textmate-crystal
  brew cask install textmate-cucumber
  brew cask install textmate-editorconfig
  brew cask install textmate-elixir
  brew cask install textmate-rubocop
  brew cask install texshop
  brew cask install transmission
  brew cask install tower-beta
  brew cask install unicodechecker
  brew cask install vagrant
  brew cask install vagrant-manager
  brew cask install virtualbox
  brew cask install vlc-nightly
  brew cask install wineskin-winery
  brew cask install xquartz


  # Conversion Tools

  local converters_dir='/Applications/Converters.localized'
  /bin/mkdir -p "${converters_dir}/.localized"
  echo '"Converters" = "Konvertierungswerkzeuge";' > "${converters_dir}/.localized/de.strings"
  echo '"Converters" = "Conversion Tools";' > "${converters_dir}/.localized/en.strings"
  brew cask install handbrake  --appdir="${converters_dir}"
  brew cask install makemkv    --appdir="${converters_dir}"
  brew cask install mkvtools   --appdir="${converters_dir}"
  brew cask install xld        --appdir="${converters_dir}"
  brew cask install xnconvert  --appdir="${converters_dir}"
  brew cask install image2icon --appdir="${converters_dir}"
  brew cask install imageoptim --appdir="${converters_dir}"

}
