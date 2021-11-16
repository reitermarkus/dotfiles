# frozen_string_literal: true

require 'defaults'
require 'killall'

task :menubar do
  puts ANSI.blue { 'Configuring menu bar …' }

  # Set Clock Format
  defaults 'com.apple.menuextra.clock' do
    write 'DateFormat', 'HH:mm'
    write 'FlashDateSeparators', false
    write 'IsAnalog', false
  end

  # Show Battery Percentage
  defaults 'com.apple.menuextra.battery' do
    write 'ShowPercent', true
  end

  # Only show Icon for “Switch Account” Menu
  defaults 'NSGlobalDomain' do
    write 'userMenuExtraStyle', 2
  end

  # Set Menubar Items
  defaults 'com.apple.systemuiserver' do
    write 'menuExtras', [
      '/System/Library/CoreServices/Menu Extras/TimeMachine.menu',
      '/System/Library/CoreServices/Menu Extras/Bluetooth.menu',
      '/System/Library/CoreServices/Menu Extras/AirPort.menu',
      '/System/Library/CoreServices/Menu Extras/VPN.menu',
      '/System/Library/CoreServices/Menu Extras/Volume.menu',
      '/System/Library/CoreServices/Menu Extras/Battery.menu',
      '/System/Library/CoreServices/Menu Extras/Clock.menu',
      '/System/Library/CoreServices/Menu Extras/TextInput.menu',
      '/System/Library/CoreServices/Menu Extras/User.menu',
    ]
  end

  killall 'cfprefsd'
  killall 'SystemUIServer'
end
