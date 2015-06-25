if hash npm; then

  npm_install_if_missing() {

    if hash "$1"; then
      cecho '“$1” already installed.' $green
    else
      cecho 'Installing “$1” …'
      npm install -g "$1"
    fi

  }

  brew cask ls imageoptim &>/dev/null && npm_install_if_missing imageoptim
  npm_install_if_missing svgexport

fi
