apply_defaults() {

  /usr/bin/killall cfprefsd &>/dev/null
  sudo -E -- /usr/sbin/chown -R "${USER}:staff" ~/Library/Preferences

}
