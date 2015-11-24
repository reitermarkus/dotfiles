#!/bin/sh


# User Interface & User Experience Defaults

defaults_ui_ux() {

  echo -b 'Setting defaults for User Interface …'

  # Expand Save Panel by Default
  defaults write NSGlobalDomain NSNavPanelExpandedStateForSaveMode  -bool true
  defaults write NSGlobalDomain NSNavPanelExpandedStateForSaveMode2 -bool true
  defaults write NSGlobalDomain PMPrintingExpandedStateForPrint     -bool true
  defaults write NSGlobalDomain PMPrintingExpandedStateForPrint2    -bool true

  # Keep Open Windows on Quit
  defaults write NSGlobalDomain NSQuitAlwaysKeepsWindows -bool true

  # Disable Font Smoothing
  defaults write NSGlobalDomain AppleFontSmoothing -int 0

  # Enable Help Viewer Non-Floating Mode
  defaults write com.apple.helpviewer DevMode -bool true

}
