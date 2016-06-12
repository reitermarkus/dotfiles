defaults_transmission() {

  # Transmission
  /usr/bin/defaults write org.m0k.transmission AutoSize               -bool true
  /usr/bin/defaults write org.m0k.transmission CheckQuitDownloading   -bool true
  /usr/bin/defaults write org.m0k.transmission CheckRemoveDownloading -bool true
  /usr/bin/defaults write org.m0k.transmission DeleteOriginalTorrent  -bool true
  /usr/bin/defaults write org.m0k.transmission DownloadAskManual      -bool true
  /usr/bin/defaults write org.m0k.transmission DownloadAskMulti       -bool true
  /usr/bin/defaults write org.m0k.transmission RenamePartialFiles     -bool true
  /usr/bin/defaults write org.m0k.transmission WarningDonate          -bool false
  /usr/bin/defaults write org.m0k.transmission WarningLegal           -bool false

}
