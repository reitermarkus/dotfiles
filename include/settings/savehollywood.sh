defaults_savehollywood() {

  # SaveHollywood Screensaver
  if is_app_installed fr.whitebox.SaveHollywood && has_enough_space; then
    defaults -currentHost write com.apple.screensaver moduleDict -dict-add moduleName -string 'SaveHollywood'
    defaults -currentHost write com.apple.screensaver moduleDict -dict-add path       -string "$(mdfind -onlyin / kMDItemCFBundleIdentifier==fr.whitebox.SaveHollywood)"
    defaults -currentHost write com.apple.screensaver moduleDict -dict-add type       -int    0

    python "${dotfiles_dir}/scripts/download-apple-tv-screensavers.py"

    defaults -currentHost write fr.whitebox.SaveHollywood assets.library               -array "${HOME}/Library/Screen Savers/Videos"
    defaults -currentHost write fr.whitebox.SaveHollywood assets.randomOrder           -bool  true
    defaults -currentHost write fr.whitebox.SaveHollywood assets.startWhereLeftOff     -bool  false
    defaults -currentHost write fr.whitebox.SaveHollywood frame.drawBorder             -bool  false
    defaults -currentHost write fr.whitebox.SaveHollywood frame.randomPosition         -bool  false
    defaults -currentHost write fr.whitebox.SaveHollywood frame.scaling                -int   1
    defaults -currentHost write fr.whitebox.SaveHollywood frame.showMetadata.mode      -bool  false
    defaults -currentHost write fr.whitebox.SaveHollywood movie.volume.mode            -int   1
    defaults -currentHost write fr.whitebox.SaveHollywood screen.mainDisplayOnly       -bool  false
  else
    defaults -currentHost write com.apple.screensaver moduleDict -dict-add moduleName -string 'Arabesque'
    defaults -currentHost write com.apple.screensaver moduleDict -dict-add path       -string '/System/Library/Screen Savers/Arabesque.qtz'
    defaults -currentHost write com.apple.screensaver moduleDict -dict-add type       -int    1
  fi

}
