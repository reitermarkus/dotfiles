defaults_softwareupdate() {

  # Software Update
  echo -b 'Setting defaults for Software Update …'

  # Automatic Updates
  /usr/bin/sudo -E -- /usr/bin/defaults write /Library/Preferences/com.apple.commerce AutoUpdate -bool true
  /usr/bin/sudo -E -- /usr/bin/defaults write /Library/Preferences/com.apple.commerce AutoUpdateRestartRequired -bool true
  /usr/bin/sudo -E -- /usr/bin/defaults write /Library/Preferences/com.apple.SoftwareUpdate AutomaticCheckEnabled -bool true
  /usr/bin/sudo -E -- /usr/bin/defaults write /Library/Preferences/com.apple.SoftwareUpdate AutomaticDownload -bool true
  /usr/bin/sudo -E -- /usr/bin/defaults write /Library/Preferences/com.apple.SoftwareUpdate ConfigDataInstall -bool true
  /usr/bin/sudo -E -- /usr/bin/defaults write /Library/Preferences/com.apple.SoftwareUpdate CriticalUpdateInstall -bool true
  /usr/bin/sudo -E -- /usr/bin/defaults write /Library/Preferences/com.apple.SoftwareUpdate ScheduleFrequency -int 1 # daily
  /usr/bin/sudo -E -- softwareupdate --schedule on &>/dev/null

}
