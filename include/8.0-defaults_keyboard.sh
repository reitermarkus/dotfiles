#!/bin/sh


# Keyboard Defaults

defaults_keyboard() {

  echo -b 'Setting Defaults for Keyboard …'

  # Use FunctionFlip to set F4 to open Notification Center.

  if brew-cask list functionflip &>/dev/null; then
    sudo sqlite3 '/Library/Application Support/com.apple.TCC/TCC.db' \
        "insert or replace into access values('kTCCServiceAccessibility','com.kevingessner.FFHelperApp',0,1,1,NULL,NULL);"

    defaults write com.kevingessner.FunctionFlip startAtLogin -bool true

    defaults write com.kevingessner.FunctionFlip "flipped.Markus' Tastatur.0x0007003d" -bool true
    defaults write com.kevingessner.FunctionFlip "flipped.Apple Internal Keyboard / Trackpad.0x0007003d" -bool true

    open -jga FunctionFlip
  fi

  killall cfprefsd &>/dev/null

}
