is_app_installed() {

  # Check if App is installed.
  if [ -d "$(mdfind -onlyin / "kMDItemCFBundleIdentifier==${1}" | head -1)" ]; then
    return 0
  else
    return 1
  fi

}
