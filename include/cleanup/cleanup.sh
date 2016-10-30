cleanup() {

  echo -r 'Cleaning up …'

  brew_cleanup

  # Remove Adobe Patch Files.
  /bin/rm -rf /Applications/Adobe/AdobePatchFiles

  if [ -d /Applications/Adobe ];then
    /bin/rmdir /Applications/Adobe
  fi

  echo -r 'Emptying CoreSymbolication cache …'
  /usr/bin/sudo -E -- /bin/rm -rfv /System/Library/Caches/com.apple.coresymbolicationd/data | /usr/bin/xargs -0 printf 'Removing: %s\n'

}
