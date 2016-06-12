defaults_menubar() {

  # Menubar
  echo -b 'Setting defaults for Menubar …'

  # Set Clock Format
  /usr/bin/defaults write com.apple.menuextra.clock DateFormat          'HH:mm'
  /usr/bin/defaults write com.apple.menuextra.clock FlashDateSeparators -bool false
  /usr/bin/defaults write com.apple.menuextra.clock IsAnalog            -bool false

  # Show Battery Percentage
  /usr/bin/defaults write com.apple.menuextra.battery ShowPercent -bool true

  # Only show Icon for “Switch Account” Menu
  /usr/bin/defaults write NSGlobalDomain userMenuExtraStyle -int 2

  # Set Menubar Items
  /usr/bin/defaults write com.apple.systemuiserver menuExtras -array \
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

  /usr/bin/killall cfprefsd &>/dev/null
  /usr/bin/killall SystemUIServer &>/dev/null

}
