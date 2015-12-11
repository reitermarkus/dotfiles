defaults_transmission() {

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

}
