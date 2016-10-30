cleanup() {

  echo -r 'Cleaning up …'

  brew_cleanup

  echo -r 'Emptying CoreSymbolication cache …'
  /usr/bin/sudo -E -- /bin/rm -rfv /System/Library/Caches/com.apple.coresymbolicationd/data | /usr/bin/xargs -0 printf 'Removing: %s\n'

}
