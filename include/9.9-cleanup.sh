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


remove_unneeded_cask_files() {

  local caskroom=/opt/homebrew-cask/Caskroom

  # Remove Adobe CC installers.
  rm -rf "${caskroom}"/adobe-*-cc*/latest/*/

  # Remove PKG installers.
  find "${caskroom}" -iname '*.pkg' -print0 | xargs -0 rm -rfv | xargs -0 printf 'Removing: %s\n'

  # Remove invisible files.
  find -E "${caskroom}" -iregex \
     '.*/(\.background|\.com\.apple\.timemachine\.supported|\.DS_Store|\.DocumentRevisions|\.fseventsd|\.VolumeIcon\.icns|\.TemporaryItems|\.Trash).*' \
      -print0 | xargs -0 rm -rfv | xargs printf 'Removing: %s\n'

  # Remove empty directories, but leave “version” directories.
  find "${caskroom}" -depth 3 -empty -print0 | xargs -0 rm -rfv | xargs -0 printf 'Removing: %s\n'

}


remove_unneeded_dictionaries() {

  echo -r 'Removing unneeded Dictionaries …'
  find -E /Library/Dictionaries -depth 1 -iregex \
    '.*(Chinese|Dutch|French|française|Hindi|Japanese|Daijirin|Korean|Norwegian|Portuguese|Russian|Spanish|Española|Swedish|Thai|Turkish).*' \
    -print0 | xargs -0 sudo rm -rf | xargs -0 printf 'Removing: %s\n'

}


remove_coresymbolicationd_cache() {

  echo -r 'Emptying CoreSymbolication cache …'
  sudo rm -rfv /System/Library/Caches/com.apple.coresymbolicationd/data | xargs -0 printf 'Removing: %s\n'

}


cleanup() {

  echo -r 'Cleaning up …'

  brew_cleanup
  link_textmate_to_avian
  relocate_microsoft_preferences

  remove_unneeded_cask_files
  remove_unneeded_dictionaries
  remove_coresymbolicationd_cache

  if remove_dotfiles_dir &>/dev/null; then remove_dotfiles_dir; fi

}
