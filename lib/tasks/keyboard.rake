# frozen_string_literal: true

require 'defaults'

task :keyboard do
  puts ANSI.blue { 'Switching to Austrian keyboard layout …' }
  defaults 'com.apple.HIToolbox' do
    write 'AppleInputSourceHistory', []
    write 'AppleSavedCurrentInputSource', {}
    write 'AppleCurrentKeyboardLayoutInputSourceID', 'com.apple.keylayout.Austrian'
    write 'AppleEnabledInputSources', [{
      'InputSourceKind' => 'Keyboard Layout',
      'KeyboardLayout ID' => 92,
      'KeyboardLayout Name' => 'Austrian',
    }]
  end

  # Disable automatic period substitution by double-tapping space.
  defaults 'NSGlobalDomain' do
    write 'NSAutomaticPeriodSubstitutionEnabled', false
  end

  capture '/usr/bin/killall', 'cfprefsd'
end
