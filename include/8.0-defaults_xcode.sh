#!/bin/sh


# Xcode Defaults

defaults_xcode() {

  echo -b 'Setting Defaults for Xcode …'

  defaults write com.apple.dt.xcode DVTTextIndentUsingTabs -bool false
  defaults write com.apple.dt.xcode DVTTextIndentTabWidth -int 2
  defaults write com.apple.dt.xcode DVTTextIndentWidth -int 2
  defaults write com.apple.dt.xcode DVTTextShowLineNumbers -bool true
  defaults write com.apple.dt.xcode NSNavPanelExpandedStateForSaveMode -bool true

}
