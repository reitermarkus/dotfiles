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
    write 'NSStatusItem Visible com.apple.menuextra.TimeMachine', true
    write 'NSStatusItem Visible com.apple.menuextra.vpn', true
    write 'menuExtras', [
      '/System/Library/CoreServices/Menu Extras/TimeMachine.menu',
      '/System/Library/CoreServices/Menu Extras/Bluetooth.menu',
      '/System/Library/CoreServices/Menu Extras/AirPort.menu',
      '/System/Library/CoreServices/Menu Extras/VPN.menu',
      '/System/Library/CoreServices/Menu Extras/Volume.menu',
      '/System/Library/CoreServices/Menu Extras/Battery.menu',
      '/System/Library/CoreServices/Menu Extras/TextInput.menu',
      '/System/Library/CoreServices/Menu Extras/User.menu',
      '/System/Library/CoreServices/Menu Extras/Clock.menu',
    ]
  end

  defaults 'com.apple.controlcenter' do
    write 'NSStatusItem Visible AccessibilityShortcuts', false
    write 'NSStatusItem Visible AirDrop', false
    write 'NSStatusItem Visible BentoBox', false
    write 'NSStatusItem Visible Bluetooth', true
    write 'NSStatusItem Visible Clock', true
    write 'NSStatusItem Visible FocusModes', true
    write 'NSStatusItem Visible NowPlaying', true
    write 'NSStatusItem Visible ScreenMirroring', false
    write 'NSStatusItem Visible Sound', true
    write 'NSStatusItem Visible UserSwitcher', true
    write 'NSStatusItem Visible WiFi', true
  end

  defaults current_host: 'com.apple.controlcenter' do
    write 'AccessibilityShortcuts', 8
    write 'AirDrop', 2
    write 'Bluetooth', 18
    write 'FocusModes', 2
    write 'Display', 2
    write 'NowPlaying', 2
    write 'ScreenMirroring', 8
    write 'Sound', 18
    write 'UserSwitcher', 18
    write 'WiFi', 18
  end

  killall 'cfprefsd'
  killall 'SystemUIServer'
end
