defaults_locate_db() {

  # Locate Database
  if sudo launchctl list com.apple.locate &>/dev/null; then
    echo -g 'Locate DB already enabled.'
  else
    echo -b 'Enabling Locate DB …'
    sudo launchctl load -w /System/Library/LaunchDaemons/com.apple.locate.plist
  fi

}
