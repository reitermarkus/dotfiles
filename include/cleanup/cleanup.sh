cleanup() {

  echo -r 'Cleaning up …'

  brew_cleanup

  # Remove Adobe Patch Files.
  rm -rf /Applications/Adobe/AdobePatchFiles
  rmdir /Applications/Adobe &>/dev/null

  echo -r 'Emptying CoreSymbolication cache …'
  sudo rm -rfv /System/Library/Caches/com.apple.coresymbolicationd/data | xargs -0 printf 'Removing: %s\n'

  echo -r 'Removing unneeded Dictionaries …'
  find -E /Library/Dictionaries -depth 1 -iregex \
    '.*(Chinese|Dutch|French|française|Hindi|Japanese|Daijirin|Korean|Norwegian|Portuguese|Russian|Spanish|Española|Swedish|Thai|Turkish).*' \
    -print0 | xargs -0 sudo rm -rf | xargs -0 printf 'Removing: %s\n'

  if type remove_dotfiles_dir &>/dev/null; then remove_dotfiles_dir; fi

}
