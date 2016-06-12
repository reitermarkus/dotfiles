defaults_launchbar() {

  # Launchbar
  /usr/bin/defaults write at.obdev.LaunchBar Autohide                    -bool   true
  /usr/bin/defaults write at.obdev.LaunchBar AppendEnglishFilename       -bool   true
  /usr/bin/defaults write at.obdev.LaunchBar LaunchBarWindowWidth        -int    680
  /usr/bin/defaults write at.obdev.LaunchBar LaunchBarHorizontalPosition -float  0.5
  /usr/bin/defaults write at.obdev.LaunchBar LaunchBarVerticalPosition   -float  0.805
  /usr/bin/defaults write at.obdev.LaunchBar ShowDockIcon                -bool   false
  /usr/bin/defaults write at.obdev.LaunchBar Theme                       -string 'at.obdev.LaunchBar.theme.Yosemite'

  add_app_to_tcc at.obdev.LaunchBar at.obdev.LaunchBar-AppleScript-Runner
  add_login_item at.obdev.LaunchBar hidden

}
