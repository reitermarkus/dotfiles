defaults_steam() {

  echo -b 'Setting defaults for Steam …'

  if "$(/usr/bin/osascript -e 'tell application "System Events" to get the name of every login item contains "Steam"')"; then
    /usr/bin/osascript -e 'tell application "System Events" to delete login item "Steam"'
  fi

}
