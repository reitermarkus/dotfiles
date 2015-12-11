apply_defaults() {

  killall cfprefsd &>/dev/null
  sudo chown -R "${USER}:staff" ~/Library/Preferences

}
