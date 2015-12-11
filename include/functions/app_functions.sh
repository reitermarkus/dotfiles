#!/bin/sh


# Check if app is installed.

app_installed() {

  if [ -d "$(mdfind -onlyin / "kMDItemCFBundleIdentifier==${@}" | head -1)" ]; then
    return 0
  else
    return 1
  fi

}


# Add App to Login Items.

add_login_item() {

  local bundle_id="${1}"
  hidden=false

  if [ "${2}" == 'hidden' ]; then
    hidden=true
  fi

  if app_installed "${bundle_id}"; then
    osascript \
      -e 'tell application "System Events"' \
      -e "make login item with properties {path:\"$(mdfind -onlyin / kMDItemCFBundleIdentifier=="${bundle_id}")\", hidden:${hidden}}" \
      -e 'end tell' \
      -e 'return'
  fi

}


# Add App to Accessibility Database.

add_app_to_tcc() {

  if app_installed "${1}"; then
    for bundle_id in "${@}"; do
      sudo sqlite3 '/Library/Application Support/com.apple.TCC/TCC.db' \
      "insert or replace into access values('kTCCServiceAccessibility','${bundle_id}',0,1,1,NULL,NULL);"
    done
  fi

}
