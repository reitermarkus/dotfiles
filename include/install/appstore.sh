#!/bin/sh


# Install Apps from the Mac App Store

appstore_cli() {

  python "${dotfiles_dir}/scripts/appstore-cli.py" ${@}

}


# Install App Store Applications

install_appstore_apps() {

  appstore_cli update

  apps=(
    608292802 # Auction Sniper for eBay
    417375580 # BetterSnapTool
    420212497 # Byword
    924726344 # Deliveries
    480664966 # Fusio
    463541543 # Gemini
    402989379 # iStudiez Pro
    409183694 # Keynote
    482898991 # LiveReload
    409203825 # Numbers
    409201541 # Pages
    419891002 # RapidClick
    954196690 # RegexToolbox
    443370764 # Repeater
    892115848 # yRegex
  )

  appstore_cli install "${apps[*]}"

}


# Install Xcode

install_xcode() {

  appstore_cli install 497799835 # Xcode
  until sudo xcodebuild -license accept &>/dev/null; do sleep 5; done &
  wait_for_xcode_pid=${!}

}


check_if_xcode_is_installed() {

  if ps -p ${wait_for_xcode_pid} &>/dev/null; then
    echo -b "Still waiting for Xcode to install …"
    wait ${wait_for_xcode_pid} && echo -g 'Xcode installed and license accepted.'
  fi

}
