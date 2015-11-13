#!/bin/sh


# User Interface & User Experience Defaults

defaults_ui_ux() {

  echo -b 'Setting Defaults for User Interface …'

  # Expand Save Panel by Default
  defaults write NSGlobalDomain NSNavPanelExpandedStateForSaveMode -bool true
  defaults write NSGlobalDomain PMPrintingExpandedStateForPrint -bool true
  defaults write NSGlobalDomain PMPrintingExpandedStateForPrint2 -bool true

  # Keep Open Windows on Quit
  defaults write NSGlobalDomain NSQuitAlwaysKeepsWindows -bool true


  # Disable Font Smoothing
  defaults write NSGlobalDomain AppleFontSmoothing -int 0


}
