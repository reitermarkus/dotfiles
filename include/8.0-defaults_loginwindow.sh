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

  # Save open Windows on Logout.
  defaults write com.apple.loginwindow TALLogoutSavesState -bool true

  # Apply Login Text on FileVault Pre-Boot Screen
  sudo rm -f /System/Library/Caches/com.apple.corestorage/EFILoginLocalizations/preferences.efires

  # Set Account Picture
  USER_PICTURE="/Library/User Pictures/${USER}"

  sudo rm -f "${USER_PICTURE}"*
  dscl . delete "${HOME}" JPEGPhoto
  dscl . delete "${HOME}" Picture

  # If no local Picture is found, use Gravatar.
  if [ -f "${HOME}/Library/User Pictures/${USER}"* ]; then
    sudo cp -f "${HOME}/Library/User Pictures/${USER}"* "${USER_PICTURE}"
  else
    sudo curl -o "${USER_PICTURE}" --silent --location "http://gravatar.com/avatar/$(md5 -s $(git config --global user.email) | awk '{print $NF}').png?s=256"
  fi

  dscl . append "${HOME}" Picture "${USER_PICTURE}"

  sudo chown "${USER}:staff" "${USER_PICTURE}"
  sudo chmod a=r,u+w "${USER_PICTURE}"

}
