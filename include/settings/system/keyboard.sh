#!/bin/sh


# Keyboard Defaults

defaults_keyboard() {

  echo -b 'Setting defaults for Keyboard …'

  # Austrian Keyboard Layout

  /usr/bin/defaults delete com.apple.HIToolbox AppleInputSourceHistory &>/dev/null
  /usr/bin/defaults delete com.apple.HIToolbox AppleSavedCurrentInputSource &>/dev/null
  /usr/bin/defaults write  com.apple.HIToolbox AppleCurrentKeyboardLayoutInputSourceID -string 'com.apple.keylayout.Austrian'
  /usr/bin/defaults write  com.apple.HIToolbox AppleEnabledInputSources -array '''
    <dict>
      <key>InputSourceKind</key><string>Keyboard Layout</string>
      <key>KeyboardLayout ID</key><integer>92</integer>
      <key>KeyboardLayout Name</key><string>Austrian</string>
    </dict>
  '''

  # Disable automatic period substitution by double-tapping space.

  /usr/bin/defaults write NSGlobalDomain NSAutomaticPeriodSubstitutionEnabled -bool false

  /usr/bin/killall cfprefsd &>/dev/null

}
