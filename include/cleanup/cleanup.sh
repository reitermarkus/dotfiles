cleanup() {

  echo -r 'Cleaning up …'

  if [ -d /opt ]; then
    sudo chflags hidden /opt
  fi

  brew_cleanup

  # Remove Adobe Patch Files.
  /bin/rm -rf /Applications/Adobe/AdobePatchFiles
  /bin/rmdir /Applications/Adobe &>/dev/null

  echo -r 'Emptying CoreSymbolication cache …'
  sudo /bin/rm -rfv /System/Library/Caches/com.apple.coresymbolicationd/data | /usr/bin/xargs -0 printf 'Removing: %s\n'

  if type remove_dotfiles_dir &>/dev/null; then remove_dotfiles_dir; fi

}
