defaults_startup() {

  # Startup
  echo -b 'Setting defaults for Startup …'

  # Disable Boot Sound
  /usr/bin/sudo -E -- nvram SystemAudioVolume=" "

  # Enable Verbose Boot
  /usr/bin/sudo -E -- nvram boot-args='-v'

  # Restart on Power Failure or Freeze
  /usr/bin/sudo -E -- systemsetup -setrestartpowerfailure on &>/dev/null
  /usr/bin/sudo -E -- systemsetup -setrestartfreeze       on &>/dev/null

  # Enable Remote Apple Events, Remote Login & Remote Management
  /usr/bin/sudo -E -- systemsetup -setremoteappleevents on &>/dev/null
  /usr/bin/sudo -E -- systemsetup -setremotelogin       on &>/dev/null
  /usr/bin/sudo -E -- /System/Library/CoreServices/RemoteManagement/ARDAgent.app/Contents/Resources/kickstart -activate -configure -access -on -users admin -privs -all -restart -agent -menu &>/dev/null

}
