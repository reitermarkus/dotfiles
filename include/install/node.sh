npm() {

  NPM_INSTALLED_PACKAGES="${NPM_INSTALLED_PACKAGES:-$(command npm -g list | /usr/bin/awk '{print $NF}' | /usr/bin/sed 's/@.*$//' | /usr/bin/sed '1d;$d' 2>/dev/null)}"

  case "${1} ${2}" in
  "-g install"|"install -g")
    local package="${3}"
    if array_contains_exactly "${NPM_INSTALLED_PACKAGES}" "${package}"; then
      echo -g "${package} is already installed."
    else
      echo -b "Installing ${package} …"
      command npm "${@}"
    fi
    ;;
  *)
    command npm "${@}"
    ;;
  esac

}

install_npm_packages() {

  echo -b 'Updating Node packages …'
  npm -g update
  npm -g upgrade

  # Install Node Packages
  brew cask list imageoptim &>/dev/null && npm -g install imageoptim-cli
  npm -g install svgexport

}
