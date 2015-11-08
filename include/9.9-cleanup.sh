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


remove_unneeded_dictionaries() {
  find -E /Library/Dictionaries -depth 1 -iregex \
    '.*(Chinese|Dutch|French|française|Hindi|Japanese|Daijirin|Korean|Norwegian|Portuguese|Russian|Spanish|Española|Swedish|Thai|Turkish).*' \
    -print0 | xargs -0 sudo rm -rf
}


remove_system_migration_quarantine() {
  sudo rm -rf /Library/SystemMigration/History/*
}


cleanup() {

  echo -r 'Cleaning up …'

  brew_cleanup
  link_textmate_to_avian
  relocate_microsoft_preferences

  remove_unneeded_dictionaries
  remove_system_migration_quarantine

  if remove_dotfiles_dir &>/dev/null; then remove_dotfiles_dir; fi

}
