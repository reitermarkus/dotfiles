defaults_launchbar() {

  # Launchbar
  defaults write at.obdev.LaunchBar Autohide                    -bool   true
  defaults write at.obdev.LaunchBar AppendEnglishFilename       -bool   true
  defaults write at.obdev.LaunchBar LaunchBarWindowWidth        -int    680
  defaults write at.obdev.LaunchBar LaunchBarHorizontalPosition -float  0.5
  defaults write at.obdev.LaunchBar LaunchBarVerticalPosition   -float  0.805
  defaults write at.obdev.LaunchBar ShowDockIcon                -bool   false
  defaults write at.obdev.LaunchBar Theme                       -string 'at.obdev.LaunchBar.theme.Yosemite'

  add_app_to_tcc at.obdev.LaunchBar at.obdev.LaunchBar-AppleScript-Runner
  add_login_item at.obdev.LaunchBar hidden

}
