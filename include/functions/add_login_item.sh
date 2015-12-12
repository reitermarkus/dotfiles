add_login_item() {

  # Add App to Login Items.
  local bundle_id="${1}"
  hidden=false

  if [ "${2}" == 'hidden' ]; then
    hidden=true
  fi

  if is_app_installed "${bundle_id}"; then
    osascript \
      -e 'tell application "System Events"' \
      -e "make login item with properties {path:\"$(mdfind -onlyin / kMDItemCFBundleIdentifier=="${bundle_id}")\", hidden:${hidden}}" \
      -e 'end tell' \
      -e 'return'
  fi

}
