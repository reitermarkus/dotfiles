install_brew() {
  export HOMEBREW_NO_AUTO_UPDATE=1

  sudo /bin/mkdir -p /usr/local/sbin

  if which brew &>/dev/null; then
    echo -g 'Homebrew is already installed.'
  else
    echo -b 'Installing Homebrew …'
    /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
  fi

  echo -b 'Updating Homebrew …'
  brew update --force
}


# Hombrew Install Function

brew() {

  BREW_INSTALLED_CASKS="${BREW_INSTALLED_CASKS:-$(command brew cask list 2>/dev/null)}"

  case "${1}" in
  cask)
    case "${2}" in
    install)
      local cask="${3}"

      if array_contains_exactly "${BREW_INSTALLED_CASKS[@]}" "${cask##*/}"; then
        echo -g "${cask} is already installed."
      else
        echo -b "Installing ${cask} …"
        command brew "${@}" \
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
  *)
    command brew "${@}"
    ;;
  esac

}


# Homebrew Taps
install_brew_taps() {
  local installed_taps="$(brew tap 2>/dev/null)"

  local taps=(
    caskroom/cask
    caskroom/drivers
    caskroom/fonts
    caskroom/versions

    homebrew/command-not-found
    homebrew/services

    fisherman/tap

    jonof/kenutils
    reitermarkus/tap
    bfontaine/utils
  )

  local pids=( )

  for tap in "${taps[@]}"; do
    if array_contains_exactly "${installed_taps[@]}" "${tap}"; then
      echo -g "${tap} is already tapped."
    else
      echo -b "Tapping ${tap} …"
      brew tap "${tap}" &>/dev/null &
      pids+=( $! )
    fi
  done

  for pid in "${pids[@]}"; do
    wait "${pid}"
  done
}


# Install Homebrew Formulae
install_brew_formulae() {
  local installed_formulae="$(brew list 2>/dev/null)"

  local formulae=(
    bash
    bash-completion
    carthage
    ccache
    clang-format
    cmake
    crystal-lang
    dockutil
    dnsmasq
    gcc
    git
    git-lfs
    ghc
    iperf3
    node
    fish
    fisherman
    llvm
    lockscreen
    mackup
    mas
    ocaml
    ocamlbuild
    pngout
    python
    rlwrap
    rbenv
    rbenv-binstubs
    rbenv-system-ruby
    rbenv-bundler-ruby-version
    rfc
    rustup-init
    sshfs
    terminal-notifier
    thefuck
    trash
    tree
    yarn
  )

  if is_desktop; then
    formulae+=( apcupsd )
  fi

  for formula in "${formulae[@]}"; do
    {
      if ! array_contains_exactly "${installed_formulae[@]}" "${formula##*/}"; then
        if [ "${formula}" = 'sshfs' ]; then
          brew cask install osxfuse &>/dev/null
        fi

        brew fetch "${formula}" --deps &>/dev/null
      fi
    } &
    declare "fetch_$(/usr/bin/tr - _ <<< "${formula}")_pid=${!}"
  done

  for formula in "${formulae[@]}"; do
    fetch_pid="fetch_$(/usr/bin/tr - _ <<< "${formula}")_pid"
    wait "${!fetch_pid}"

    if array_contains_exactly "${installed_formulae[@]}" "${formula##*/}"; then
      echo -g "${formula} is already installed."
    else
      echo -b "Installing ${formula} …"
      brew install "${formula}"
    fi
  done

  if which pip3 &>/dev/null; then pip3 install --upgrade pip setuptools; fi

}

install_brew_casks() {

  # Conversion Tools

  local converters_dir='/Applications/Converters.localized'
  /bin/mkdir -p "${converters_dir}/.localized"
  echo '"Converters" = "Konvertierungswerkzeuge";' > "${converters_dir}/.localized/de.strings"
  echo '"Converters" = "Conversion Tools";' > "${converters_dir}/.localized/en.strings"
  brew cask install handbrake  --appdir="${converters_dir}"
  brew cask install makemkv    --appdir="${converters_dir}"
  brew cask install xld        --appdir="${converters_dir}"
  brew cask install xnconvert  --appdir="${converters_dir}"
  brew cask install image2icon --appdir="${converters_dir}"
  brew cask install imageoptim --appdir="${converters_dir}"

}
