defaults_arduino() {

  arduino_preferences="${HOME}/Library/Arduino15/preferences.txt"

  arduino_sketchbook_dir="${HOME}/Documents/Arduino"

  /bin/mkdir -p "${arduino_preferences%/*}"
  echo "sketchbook.path=${arduino_sketchbook_dir}" >> "${arduino_preferences}"
  /bin/mkdir -p "${arduino_sketchbook_dir}"

  echo "editor.languages.current=de_DE" >> "${arduino_preferences}"
  echo "editor.linenumbers=true"        >> "${arduino_preferences}"

  add_boardmanager_url "http://arduino.esp8266.com/stable/package_esp8266com_index.json" "${arduino_preferences}"

}


add_boardmanager_url() {

  boardmanager_urls_var='boardsmanager.additional.urls'
  preferences="${2}"

  new_url="${1}"

  /usr/bin/touch "${preferences}"

  if ! /usr/bin/grep "${new_url}" "${preferences}"; then

    current_urls="$(/usr/bin/grep "${boardmanager_urls_var}" "${preferences}" | /usr/bin/sed -E "s|${boardmanager_urls_var}=(.*)|\1|")"

    if [ "${current_urls}" != '' ]; then
      current_urls="${current_urls},"
    fi

    current_urls="${current_urls}${new_url}"

    echo "${boardmanager_urls_var}=${current_urls}" >> "${preferences}"
  fi

}