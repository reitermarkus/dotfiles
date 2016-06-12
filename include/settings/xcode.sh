defaults_xcode() {

  # Xcode
  /usr/bin/defaults write com.apple.dt.xcode DVTTextIndentUsingTabs             -bool false
  /usr/bin/defaults write com.apple.dt.xcode DVTTextIndentTabWidth              -int  2
  /usr/bin/defaults write com.apple.dt.xcode DVTTextIndentWidth                 -int  2
  /usr/bin/defaults write com.apple.dt.xcode DVTTextShowLineNumbers             -bool true
  /usr/bin/defaults write com.apple.dt.xcode NSNavPanelExpandedStateForSaveMode -bool true

}
