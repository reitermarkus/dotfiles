defaults_savehollywood() {

  # SaveHollywood Screensaver
  if is_app_installed fr.whitebox.SaveHollywood && has_enough_space; then
    /usr/bin/defaults -currentHost write com.apple.screensaver moduleDict -dict-add moduleName -string 'SaveHollywood'
    /usr/bin/defaults -currentHost write com.apple.screensaver moduleDict -dict-add path       -string "$(/usr/bin/mdfind -onlyin / kMDItemCFBundleIdentifier==fr.whitebox.SaveHollywood)"
    /usr/bin/defaults -currentHost write com.apple.screensaver moduleDict -dict-add type       -int    0

    echo -b "Downloading Apple TV Screen Savers …"
    "${dotfiles_dir}/scripts/download_apple_tv_screensavers.rb" "${HOME}/Library/Screen Savers/Videos"

    /usr/bin/defaults -currentHost write fr.whitebox.SaveHollywood assets.library               -array "${HOME}/Library/Screen Savers/Videos"
    /usr/bin/defaults -currentHost write fr.whitebox.SaveHollywood assets.randomOrder           -bool  true
    /usr/bin/defaults -currentHost write fr.whitebox.SaveHollywood assets.startWhereLeftOff     -bool  false
    /usr/bin/defaults -currentHost write fr.whitebox.SaveHollywood frame.drawBorder             -bool  false
    /usr/bin/defaults -currentHost write fr.whitebox.SaveHollywood frame.randomPosition         -bool  false
    /usr/bin/defaults -currentHost write fr.whitebox.SaveHollywood frame.scaling                -int   1
    /usr/bin/defaults -currentHost write fr.whitebox.SaveHollywood frame.showMetadata.mode      -bool  false
    /usr/bin/defaults -currentHost write fr.whitebox.SaveHollywood movie.volume.mode            -int   1
    /usr/bin/defaults -currentHost write fr.whitebox.SaveHollywood screen.mainDisplayOnly       -bool  false
  else
    /usr/bin/defaults -currentHost write com.apple.screensaver moduleDict -dict-add moduleName -string 'Arabesque'
    /usr/bin/defaults -currentHost write com.apple.screensaver moduleDict -dict-add path       -string '/System/Library/Screen Savers/Arabesque.qtz'
    /usr/bin/defaults -currentHost write com.apple.screensaver moduleDict -dict-add type       -int    1
  fi

}
