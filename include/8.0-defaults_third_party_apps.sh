#!/bin/sh


# Defaults for Third-Party Apps

defaults_third_party_apps() {

  # SaveHollywood Screensaver
  if app_installed fr.whitebox.SaveHollywood && has_enough_space; then
    defaults -currentHost write com.apple.screensaver moduleDict -dict-add moduleName -string 'SaveHollywood'
    defaults -currentHost write com.apple.screensaver moduleDict -dict-add path       -string "$(mdfind -onlyin / kMDItemCFBundleIdentifier==fr.whitebox.SaveHollywood)"
    defaults -currentHost write com.apple.screensaver moduleDict -dict-add type          -int 0

    python "${dotfiles_dir}/scripts/download-apple-tv-screensavers.py"

    defaults -currentHost write fr.whitebox.SaveHollywood assets.library               -array "${HOME}/Library/Screen Savers/Videos"
    defaults -currentHost write fr.whitebox.SaveHollywood assets.randomOrder            -bool true
    defaults -currentHost write fr.whitebox.SaveHollywood assets.startWhereLeftOff      -bool false
    defaults -currentHost write fr.whitebox.SaveHollywood frame.drawBorder              -bool false
    defaults -currentHost write fr.whitebox.SaveHollywood frame.randomPosition          -bool false
    defaults -currentHost write fr.whitebox.SaveHollywood frame.scaling                  -int 1
    defaults -currentHost write fr.whitebox.SaveHollywood frame.showMetadata.mode       -bool false
    defaults -currentHost write fr.whitebox.SaveHollywood movie.volume.mode              -int 1
    defaults -currentHost write fr.whitebox.SaveHollywood screen.mainDisplayOnly        -bool false
  else
    defaults -currentHost write com.apple.screensaver moduleDict -dict-add moduleName -string 'Arabesque'
    defaults -currentHost write com.apple.screensaver moduleDict -dict-add path       -string '/System/Library/Screen Savers/Arabesque.qtz'
    defaults -currentHost write com.apple.screensaver moduleDict -dict-add type      -int 1
  fi

  # BetterSnapTool
  if app_installed com.hegenberg.BetterSnapTool; then
    add_app_to_tcc com.hegenberg.BetterSnapTool
    add_login_item com.hegenberg.BetterSnapTool hidden

    defaults write com.hegenberg.BetterSnapTool BSTCornerRoundness          -float 4
    defaults write com.hegenberg.BetterSnapTool BSTDuplicateMenubarMenu      -bool false
    defaults write com.hegenberg.BetterSnapTool BSTPreventTopMissionControl  -bool false
    defaults write com.hegenberg.BetterSnapTool centernext_m                 -bool false
    defaults write com.hegenberg.BetterSnapTool cycle_lrm                    -bool false
    defaults write com.hegenberg.BetterSnapTool cycle_quarters               -bool false
    defaults write com.hegenberg.BetterSnapTool greenButton                   -int 100
    defaults write com.hegenberg.BetterSnapTool launchOnStartup              -bool true
    defaults write com.hegenberg.BetterSnapTool maxnext_m                    -bool false
    defaults write com.hegenberg.BetterSnapTool next_m                       -bool false
    defaults write com.hegenberg.BetterSnapTool previewAnimated              -bool false
    defaults write com.hegenberg.BetterSnapTool previewBorderWidth          -float 0
    defaults write com.hegenberg.BetterSnapTool showMenubarIcon              -bool false
    defaults write com.hegenberg.BetterSnapTool previewWindowBackgroundColor -data 62706c6973743030d40102030405061516582476657273696f6e58246f626a65637473592461726368697665725424746f7012000186a0a307080f55246e756c6cd3090a0b0c0d0e574e5357686974655c4e53436f6c6f7253706163655624636c617373463020302e310010038002d2101112135a24636c6173736e616d655824636c6173736573574e53436f6c6f72a21214584e534f626a6563745f100f4e534b657965644172636869766572d1171854726f6f74800108111a232d32373b4148505d646b6d6f747f8890939caeb1b600000000000001010000000000000019000000000000000000000000000000b8
  fi

  # Boom 2
  if app_installed com.globaldelight.Boom2; then
    add_login_item com.globaldelight.Boom2 hidden
  fi

  # Deliveries
  if app_installed com.junecloud.mac.Deliveries; then
    defaults write com.junecloud.mac.Deliveries JUNMenuBarMode  -bool true
    defaults write com.junecloud.mac.Deliveries JUNStartAtLogin -bool true
  fi

  # Dropbox
  if app_installed com.getdropbox.dropbox; then
    add_login_item com.getdropbox.dropbox hidden
  fi

  # Hazel
  if app_installed com.noodlesoft.Hazel; then
    defaults write com.noodlesoft.Hazel ScanInvisibles       -bool true
    defaults write com.noodlesoft.Hazel ShowStatusInMenuBar  -bool true
    defaults write com.noodlesoft.Hazel UpdateCheckFrequency -int  1
  fi

  # Launchbar
  if app_installed at.obdev.LaunchBar; then
    add_app_to_tcc at.obdev.LaunchBar at.obdev.LaunchBar-AppleScript-Runner
    add_login_item at.obdev.LaunchBar hidden
  fi

  # Keka
  if app_installed com.aone.keka; then
    replace_keka_archive_icons &
  fi

  # Parallels Desktop
  if app_installed com.parallels.desktop.console; then
    replace_parallels_icon &
  fi

  # Tower
  if app_installed com.fournova.Tower2; then
    defaults write com.fournova.Tower2 GTUserDefaultsGitBinary -string "$(which git)"
  fi

  # Transmission
  if app_installed org.m0k.transmission; then
    defaults write org.m0k.transmission AutoSize               -bool true
    defaults write org.m0k.transmission CheckQuitDownloading   -bool true
    defaults write org.m0k.transmission CheckRemoveDownloading -bool true
    defaults write org.m0k.transmission DeleteOriginalTorrent  -bool true
    defaults write org.m0k.transmission DownloadAskManual      -bool true
    defaults write org.m0k.transmission DownloadAskMulti       -bool true
    defaults write org.m0k.transmission RenamePartialFiles     -bool true
    defaults write org.m0k.transmission WarningDonate          -bool false
    defaults write org.m0k.transmission WarningLegal           -bool false
  fi

  killall cfprefsd &>/dev/null

}


replace_keka_archive_icons() {

  local keka_resources="$(mdfind -onlyin / 'kMDItemCFBundleIdentifier==com.aone.keka')/Contents/Resources"

  if [ -d "${keka_resources}" ]; then

    local repo='osx-archive-icons'
    local tmp_dir="/tmp/${repo}-master"

    rm -rf "${tmp_dir}"

    curl --silent --location "https://github.com/reitermarkus/${repo}/archive/master.zip" | ditto -xk - '/tmp'

    cd "${tmp_dir}" && {

      sh _convert_iconsets

      cp -f *.icns "${keka_resources}"
      for icon in '7z.7z' 'Bzip.bz' 'Bzip2.bz2' 'Gzip.gz' 'Rar.rar' 'Tar.tar' 'Tbz2.tbz2' 'Tgz.tgz' 'Zip.zip'; do

        local name="${icon%.*}"
        local extension="${icon#*.}"

        local iconset="${extension}.iconset"
        local drop_icon="drop${extension}.png"
        local future_icon="future${name}.png"
        local tab_icon="tab${name}.png"

        if [ -f "${keka_resources}/${drop_icon}" ]; then
          cp -f  "${iconset}/icon_128x128.png" "${keka_resources}/${drop_icon}"
        fi

        if [ -f "${keka_resources}/${tab_icon}" ]; then
          cp -f  "${iconset}/icon_32x32.png" "${keka_resources}/${tab_icon}"
        fi

        if [ -f "${keka_resources}/${future_icon}" ]; then
          cp -f  "${iconset}/icon_32x32.png" "${keka_resources}/${future_icon}"
        fi

      done

      if [ -f "${keka_resources}/compression.png" ]; then
        cp -f  "archive.iconset/icon_32x32.png" "${keka_resources}/compression.png"
      fi

      rm -f  "${keka_resources}/extract.png"

      cd - &>/dev/null
      rm -rf "${tmp_dir}"
    }
  fi
}


replace_parallels_icon() {

  if cd '/Applications/Parallels Desktop.app/Contents/Resources/' &>/dev/null; then

    sudo curl --silent --location 'https://github.com/reitermarkus/mirror/raw/master/Parallels.icns' -O
    sudo touch '/Applications/Parallels Desktop.app'

    cd - &>/dev/null
  fi

}
