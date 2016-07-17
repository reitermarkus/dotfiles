mas_install() {

  local id="${1}"
  local name="${2}"

  if ! mas list | grep --quiet "${id}"; then
    echo -b "Installing ${name} …"
    mas install "${id}"
  else
    echo -g "${name} is already installed."
  fi

}


# App Store Install Function

install_mas_apps() {

  if type mas &>/dev/null; then

    mas signin 'me@reitermark.us' "${PASSWORD}"

    echo -b 'Updating App Store Applications …'
    mas upgrade

    mas_install 608292802 'Auction Sniper for eBay'
    mas_install 417375580 'BetterSnapTool'
    mas_install 420212497 'Byword'
    mas_install 924726344 'Deliveries'
    mas_install 480664966 'Fusio'
    mas_install 463541543 'Gemini'
    mas_install 402989379 'iStudiez Pro'
    mas_install 409183694 'Keynote'
    mas_install 482898991 'LiveReload'
    mas_install 409203825 'Numbers'
    mas_install 409201541 'Pages'
    mas_install 419891002 'RapidClick'
    mas_install 954196690 'RegexToolbox'
    mas_install 443370764 'Repeater'
    mas_install 497799835 'Xcode'
    mas_install 892115848 'yRegex'

    sudo xcodebuild -license accept &>/dev/null

  fi

}
