defaults_parallels_desktop() {

  # Parallels Desktop

  # Replace Icon
  local app_path="$(mdfind -onlyin / 'kMDItemCFBundleIdentifier==com.parallels.desktop.console' | head -1)"
  sudo curl --silent \
    --output "${app_path}/Contents/Resources/Parallels.icns" \
    --location 'https://github.com/reitermarkus/mirror/raw/master/Parallels.icns'
  sudo touch -c "${app_path}"

  # Remove Overlay from Icon.
  LANG=C LC_CTYPE=C sudo sed -i '' s/Parallels_Desktop_Overlay_128/Parallels_Desktop_Owerlay_128/g /Applications/Parallels\ Desktop.app/Contents/MacOS/prl_client_app &>/dev/null

}
