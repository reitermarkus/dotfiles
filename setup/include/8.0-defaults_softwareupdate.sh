#!/bin/sh


# Software Update

defaults_softwareupdate() {

  # Automatic Updates
  sudo defaults write /Library/Preferences/com.apple.commerce AutoUpdate -bool true
  sudo defaults write /Library/Preferences/com.apple.commerce AutoUpdateRestartRequired -bool true
  sudo defaults write /Library/Preferences/com.apple.SoftwareUpdate AutomaticCheckEnabled -bool true
  sudo defaults write /Library/Preferences/com.apple.SoftwareUpdate AutomaticDownload -bool true
  sudo defaults write /Library/Preferences/com.apple.SoftwareUpdate ConfigDataInstall -bool true
  sudo defaults write /Library/Preferences/com.apple.SoftwareUpdate CriticalUpdateInstall -bool true
  sudo defaults write /Library/Preferences/com.apple.SoftwareUpdate ScheduleFrequency -int 1 # daily
  sudo softwareupdate --schedule on &>/dev/null

}
