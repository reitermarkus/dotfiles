defaults_parallels_desktop() {

  # Parallels Desktop
  local app_path="$(mdfind -onlyin / 'kMDItemCFBundleIdentifier==com.parallels.desktop.console' | head -1)"
  sudo curl --silent \
    --output "${app_path}/Contents/Resources/Parallels.icns" \
    --location 'https://github.com/reitermarkus/mirror/raw/master/Parallels.icns'
  sudo touch -c "${app_path}"

}
