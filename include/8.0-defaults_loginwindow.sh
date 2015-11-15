#!/bin/sh


# Login Window Defaults

defaults_loginwindow() {

  echo -b 'Setting defaults for Login Window …'

  # Disable Guest Account
  sudo defaults write /Library/Preferences/com.apple.loginwindow GuestEnabled -bool false
  sudo defaults write /Library/Preferences/com.apple.AppleFileServer guestAccess -bool false
  sudo defaults write /Library/Preferences/SystemConfiguration/com.apple.smb.server AllowGuestAccess -bool false
  sudo rm -rf /Users/Guest

  # Show the Sleep, Restart and Shut Down Buttons
  sudo defaults write /Library/Preferences/com.apple.loginwindow 'PowerOffDisabled' -bool false

  # Show Input Menu in Login Window
  sudo defaults write /Library/Preferences/com.apple.loginwindow 'showInputMenu' -bool true

  # Hide Password Hints
  sudo defaults write /Library/Preferences/com.apple.loginwindow 'RetriesUntilHint' -int 0


}
