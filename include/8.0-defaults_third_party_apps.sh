#!/bin/sh


# Defaults for Third-Party Apps

defaults_third_party_apps() {

  # Deliveries
  defaults write com.junecloud.mac.Deliveries JUNMenuBarMode  -bool true
  defaults write com.junecloud.mac.Deliveries JUNStartAtLogin -bool true

  # Parallels Desktop
  cd '/Applications/Parallels Desktop.app/Contents/Resources/' &>/dev/null && {
    echo -b 'Replacing the default Parallels Desktop icon …'
    sudo curl --progress-bar --location 'https://github.com/reitermarkus/mirror/raw/master/Parallels.icns' -O
    sudo touch '/Applications/Parallels Desktop.app'
    cd - &>/dev/null
  }

  # Tower
  defaults write com.fournova.Tower2 GTUserDefaultsGitBinary -string "$(which git)"

  # Transmission
  defaults write org.m0k.transmission AutoSize               -bool true
  defaults write org.m0k.transmission CheckQuitDownloading   -bool true
  defaults write org.m0k.transmission CheckRemoveDownloading -bool true
  defaults write org.m0k.transmission DeleteOriginalTorrent  -bool true
  defaults write org.m0k.transmission DownloadAskManual      -bool true
  defaults write org.m0k.transmission DownloadAskMulti       -bool true
  defaults write org.m0k.transmission RenamePartialFiles     -bool true
  defaults write org.m0k.transmission WarningDonate          -bool false
  defaults write org.m0k.transmission WarningLegal           -bool false

  killall cfprefsd &>/dev/null

}
