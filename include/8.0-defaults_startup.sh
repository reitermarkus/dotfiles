#!/bin/sh


# Startup Defaults

defaults_startup() {

  echo -b 'Setting Defaults for Startup …'

  # Enable Verbose Boot
  sudo nvram boot-args='-v'

  # Restart on Power Failure or Freeze
  sudo systemsetup -setrestartpowerfailure on &>/dev/null
  sudo systemsetup -setrestartfreeze       on &>/dev/null

  # Enable Remote Apple Events, Remote Login & Remote Management
  sudo systemsetup -setremoteappleevents on &>/dev/null
  sudo systemsetup -setremotelogin       on &>/dev/null
  sudo /System/Library/CoreServices/RemoteManagement/ARDAgent.app/Contents/Resources/kickstart -activate -configure -access -on -users admin -privs -all -restart -agent -menu &>/dev/null

}
