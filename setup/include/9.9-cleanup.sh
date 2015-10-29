#!/bin/sh


# Relocate Microsoft folder.

relocate_microsoft_preferences() {

  if [ -d ~/Documents/Microsoft*/ ]; then
    echo -b 'Moving Microsoft folder to Library …'
    mv ~/Documents/Microsoft*/ ~/Library/Preferences/
  fi
}


# Link Textmate folder to Avian folder.

link_textmate_to_avian() {

  local textmate_dir="${HOME}/Library/Application Support/TextMate/Managed"
  local avian_dir="${HOME}/Library/Application Support/Avian"

  if [ ! -L "${avian_dir}" ]; then
    rm -rf "${avian_dir}"

    if [ -d "${textmate_dir}" ]; then
      ln -s "${textmate_dir}" "${avian_dir}"
    fi
  fi
}


cleanup() {

  brew_cleanup
  link_textmate_to_avian
  relocate_microsoft_preferences

}
