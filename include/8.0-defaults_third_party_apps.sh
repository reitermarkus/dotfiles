#!/bin/sh


# Defaults for Third-Party Apps

defaults_third_party_apps() {

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

    echo -b 'Replacing the default Keka archive icons …'
    curl --progress-bar --location "https://github.com/reitermarkus/${repo}/archive/master.zip" | ditto -xk - '/tmp'

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

      rm -rf "${tmp_dir}"
      cd - &>/dev/null

    }
  fi
}


replace_parallels_icon() {

  if cd '/Applications/Parallels Desktop.app/Contents/Resources/' &>/dev/null; then

    echo -b 'Replacing the default Parallels Desktop icon …'
    sudo curl --progress-bar --location 'https://github.com/reitermarkus/mirror/raw/master/Parallels.icns' -O
    sudo touch '/Applications/Parallels Desktop.app'

    cd -
  fi

}
