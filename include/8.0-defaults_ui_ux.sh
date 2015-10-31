#!/bin/sh


# User Interface & User Experience Defaults

defaults_ui_ux() {

  # Expand Save Panel by Default
  defaults write NSGlobalDomain NSNavPanelExpandedStateForSaveMode -bool true
  defaults write NSGlobalDomain PMPrintingExpandedStateForPrint -bool true
  defaults write NSGlobalDomain PMPrintingExpandedStateForPrint2 -bool true

  # Keep Open Windows on Quit
  defaults write NSGlobalDomain NSQuitAlwaysKeepsWindows -bool true


  # Disable Font Smoothing
  defaults write -g AppleFontSmoothing -int 0


}
