#!/bin/sh


# Keyboard Defaults

defaults_keyboard() {

  echo -b 'Setting defaults for Keyboard …'

  # Use FunctionFlip to set F4 to open Notification Center.

  if brew-cask list functionflip &>/dev/null; then
    sudo sqlite3 '/Library/Application Support/com.apple.TCC/TCC.db' \
        "insert or replace into access values('kTCCServiceAccessibility','com.kevingessner.FFHelperApp',0,1,1,NULL,NULL);"

    defaults write com.kevingessner.FunctionFlip startAtLogin -bool true

    defaults write com.kevingessner.FunctionFlip "flipped.Markus' Tastatur.0x0007003d" -bool true
    defaults write com.kevingessner.FunctionFlip "flipped.Apple Internal Keyboard / Trackpad.0x0007003d" -bool true

    open -jga FunctionFlip
  fi

  # Austrian Keyboard Layout

  defaults delete com.apple.HIToolbox AppleInputSourceHistory &>/dev/null
  defaults delete com.apple.HIToolbox AppleSavedCurrentInputSource &>/dev/null
  defaults write  com.apple.HIToolbox AppleCurrentKeyboardLayoutInputSourceID -string 'com.apple.keylayout.Austrian'
  defaults write  com.apple.HIToolbox AppleEnabledInputSources -array '''
    <dict>
      <key>InputSourceKind</key><string>Keyboard Layout</string>
      <key>KeyboardLayout ID</key><integer>92</integer>
      <key>KeyboardLayout Name</key><string>Austrian</string>
    </dict>
  '''

  killall cfprefsd &>/dev/null

}
