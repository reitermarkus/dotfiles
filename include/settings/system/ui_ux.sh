defaults_ui_ux() {

  # User Interface & User Experience
  echo -b 'Setting defaults for User Interface …'

  # Enable Dark Mode
  /usr/bin/defaults write NSGlobalDomain AppleInterfaceStyle -string Dark

  # Expand Save Panel by Default
  /usr/bin/defaults write NSGlobalDomain NSNavPanelExpandedStateForSaveMode  -bool true
  /usr/bin/defaults write NSGlobalDomain NSNavPanelExpandedStateForSaveMode2 -bool true
  /usr/bin/defaults write NSGlobalDomain PMPrintingExpandedStateForPrint     -bool true
  /usr/bin/defaults write NSGlobalDomain PMPrintingExpandedStateForPrint2    -bool true

  # Keep Open Windows on Quit
  /usr/bin/defaults write NSGlobalDomain NSQuitAlwaysKeepsWindows -bool true

  # Disable Font Smoothing
  /usr/bin/defaults write NSGlobalDomain AppleFontSmoothing -int 0

  # Enable Help Viewer Non-Floating Mode
  /usr/bin/defaults write com.apple.helpviewer DevMode -bool true

}
