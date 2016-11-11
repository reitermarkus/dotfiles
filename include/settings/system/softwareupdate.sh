defaults_softwareupdate() {

  # Software Update
  echo -b 'Setting defaults for Software Update …'

  # Automatic Updates
  sudo -E -- /usr/bin/defaults write /Library/Preferences/com.apple.commerce AutoUpdate -bool true
  sudo -E -- /usr/bin/defaults write /Library/Preferences/com.apple.commerce AutoUpdateRestartRequired -bool true
  sudo -E -- /usr/bin/defaults write /Library/Preferences/com.apple.SoftwareUpdate AutomaticCheckEnabled -bool true
  sudo -E -- /usr/bin/defaults write /Library/Preferences/com.apple.SoftwareUpdate AutomaticDownload -bool true
  sudo -E -- /usr/bin/defaults write /Library/Preferences/com.apple.SoftwareUpdate ConfigDataInstall -bool true
  sudo -E -- /usr/bin/defaults write /Library/Preferences/com.apple.SoftwareUpdate CriticalUpdateInstall -bool true
  sudo -E -- /usr/bin/defaults write /Library/Preferences/com.apple.SoftwareUpdate ScheduleFrequency -int 1 # daily
  sudo -E -- softwareupdate --schedule on &>/dev/null

}
