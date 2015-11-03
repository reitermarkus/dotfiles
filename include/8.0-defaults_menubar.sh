#!/bin/sh


# Menubar Defaults

defaults_menubar() {

  # Set Clock Format
  defaults write com.apple.menuextra.clock DateFormat          'HH:mm'
  defaults write com.apple.menuextra.clock FlashDateSeparators -bool false
  defaults write com.apple.menuextra.clock IsAnalog            -bool false

  # Show Battery Percentage
  defaults write com.apple.menuextra.battery ShowPercent -bool true

  # Only show Icon for “Switch Account” Menu
  defaults write NSGlobalDomain userMenuExtraStyle -int 2

  # Set Menubar Items
  defaults write com.apple.systemuiserver menuExtras -array \
    '/System/Library/CoreServices/Menu Extras/TimeMachine.menu' \
    '/System/Library/CoreServices/Menu Extras/Bluetooth.menu' \
    '/System/Library/CoreServices/Menu Extras/AirPort.menu' \
    '/System/Library/CoreServices/Menu Extras/VPN.menu' \
    '/System/Library/CoreServices/Menu Extras/Volume.menu' \
    '/System/Library/CoreServices/Menu Extras/Battery.menu' \
    '/System/Library/CoreServices/Menu Extras/Clock.menu' \
    '/System/Library/CoreServices/Menu Extras/TextInput.menu' \
    '/System/Library/CoreServices/Menu Extras/User.menu' \
  ;

  killall cfprefsd &>/dev/null
  killall SystemUIServer &>/dev/null

}
