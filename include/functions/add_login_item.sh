add_login_item() {

  # Add App to Login Items.
  local bundle_id="${1}"
  local hidden=false

  if [ "${2}" == 'hidden' ]; then
    hidden=true
  fi

  local path="$(/usr/bin/mdfind -onlyin / kMDItemCFBundleIdentifier=="${bundle_id}" | /usr/bin/head -1)"

  if [ -d "${path}" ]; then
    /usr/bin/osascript -l JavaScript \
      -e "'use strict';                                   " \
      -e "                                                " \
      -e "ObjC.import('stdlib')                           " \
      -e "                                                " \
      -e "var systemEvents = Application('System Events') " \
      -e "                                                " \
      -e "var newLoginItem = systemEvents.LoginItem({     " \
      -e "  path: '${path}',                              " \
      -e "  hidden: ${hidden}                             " \
      -e "})                                              " \
      -e "                                                " \
      -e "systemEvents.loginItems.push(newLoginItem)      " \
      -e "                                                " \
      -e "$.exit(0)                                       " \
      -e "                                                "
  fi

}
