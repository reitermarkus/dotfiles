#!/bin/sh


# Defaults for Third-Party Apps

defaults_third_party_apps() {

  # Deliveries
  defaults write com.junecloud.mac.Deliveries JUNMenuBarMode  -bool true
  defaults write com.junecloud.mac.Deliveries JUNStartAtLogin -bool true

  # Keka
  replace_keka_archive_icons

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


replace_keka_archive_icons() {

  local keka_resources="$(mdfind -onlyin / 'kMDItemCFBundleIdentifier==com.aone.keka')/Contents/Resources"

  if [ -d "${keka_resources}" ]; then

    local repo='osx-archive-icons'
    local tmp_dir="/tmp/${repo}-master"

    rm -rf "${tmp_dir}"

    echo -b 'Replacing Keka Archive Icons …'
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
