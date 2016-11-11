defaults_startup() {

  # Startup Disk

  if [ "$(/usr/sbin/diskutil info / | /usr/bin/awk '/Volume Name:/ {gsub(".*:\ *", ""); print $0}')" != 'Macintosh' ]; then
    echo -b "Renaming startup disk to 'Macintosh' …"
    /usr/sbin/diskutil rename / "Macintosh"
  fi


  # Startup
  echo -b 'Setting defaults for Startup …'

  # Disable Boot Sound
  sudo -E -- nvram SystemAudioVolume=" "

  # Enable Verbose Boot
  sudo -E -- nvram boot-args='-v'

  # Restart on Power Failure or Freeze
  sudo -E -- systemsetup -setrestartpowerfailure on &>/dev/null
  sudo -E -- systemsetup -setrestartfreeze       on &>/dev/null

  # Enable Remote Apple Events, Remote Login & Remote Management
  sudo -E -- systemsetup -setremoteappleevents on &>/dev/null
  sudo -E -- systemsetup -setremotelogin       on &>/dev/null
  sudo -E -- /System/Library/CoreServices/RemoteManagement/ARDAgent.app/Contents/Resources/kickstart -activate -configure -access -on -users admin -privs -all -restart -agent -menu &>/dev/null

}
