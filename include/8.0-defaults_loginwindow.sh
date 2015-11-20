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

  # Show Login Text
  if is_laptop; then
    sudo defaults write /Library/Preferences/com.apple.loginwindow.plist LoginwindowText \
      "If found, please contact the owner:\nme@reitermark.us\n@reitermarkus"
  else
    sudo defaults write /Library/Preferences/com.apple.loginwindow.plist LoginwindowText ""
  fi

  # Apply Login Text on FileVault Pre-Boot Screen
  sudo rm -f /System/Library/Caches/com.apple.corestorage/EFILoginLocalizations/preferences.efires

}
