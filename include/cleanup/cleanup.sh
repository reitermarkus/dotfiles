cleanup() {

  echo -r 'Cleaning up …'

  brew_cleanup

  # Remove Adobe Patch Files.
  /bin/rm -rf /Applications/Adobe/AdobePatchFiles
  /bin/rmdir /Applications/Adobe &>/dev/null

  echo -r 'Emptying CoreSymbolication cache …'
  sudo /bin/rm -rfv /System/Library/Caches/com.apple.coresymbolicationd/data | /usr/bin/xargs -0 printf 'Removing: %s\n'

  echo -r 'Removing unneeded Dictionaries …'
  /usr/bin/find -E /Library/Dictionaries -depth 1 -iregex \
    '.*(Chinese|Dutch|French|française|Hindi|Japanese|Daijirin|Korean|Norwegian|Portuguese|Russian|Spanish|Española|Swedish|Thai|Turkish).*' \
    -print0 | /usr/bin/xargs -0 sudo /bin/rm -rf | /usr/bin/xargs -0 printf 'Removing: %s\n'

  if type remove_dotfiles_dir &>/dev/null; then remove_dotfiles_dir; fi

}
