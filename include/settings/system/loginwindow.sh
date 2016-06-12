defaults_loginwindow() {

  # Login Window
  echo -b 'Setting defaults for Login Window …'

  # Disable Guest Account
  sudo /usr/bin/defaults write /Library/Preferences/com.apple.loginwindow GuestEnabled -bool false
  sudo /usr/bin/defaults write /Library/Preferences/com.apple.AppleFileServer guestAccess -bool false
  sudo /usr/bin/defaults write /Library/Preferences/SystemConfiguration/com.apple.smb.server AllowGuestAccess -bool false
  sudo /bin/rm -rf /Users/Guest

  # Automatically log out the Guest when idle.
  install_launchagent_logout_guest_on_idle

  # Show the Sleep, Restart and Shut Down Buttons
  sudo /usr/bin/defaults write /Library/Preferences/com.apple.loginwindow 'PowerOffDisabled' -bool false

  # Show Input Menu in Login Window
  sudo /usr/bin/defaults write /Library/Preferences/com.apple.loginwindow 'showInputMenu' -bool true

  # Hide Password Hints
  sudo /usr/bin/defaults write /Library/Preferences/com.apple.loginwindow 'RetriesUntilHint' -int 0

  # Show Login Text
  if is_laptop; then
    sudo /usr/bin/defaults write /Library/Preferences/com.apple.loginwindow.plist LoginwindowText \
      "If found, please contact the owner:\nme@reitermark.us\n@reitermarkus"
  else
    sudo /usr/bin/defaults write /Library/Preferences/com.apple.loginwindow.plist LoginwindowText ""
  fi

  # Save open Windows on Logout.
  /usr/bin/defaults write com.apple.loginwindow TALLogoutSavesState -bool true

  # Apply Login Text on FileVault Pre-Boot Screen
  sudo /bin/rm -f /System/Library/Caches/com.apple.corestorage/EFILoginLocalizations/preferences.efires

  # Set Account Picture
  USER_PICTURE="/Library/User Pictures/${USER}"

  sudo /bin/rm -f "${USER_PICTURE}"*
  /usr/bin/dscl . delete "${HOME}" JPEGPhoto
  /usr/bin/dscl . delete "${HOME}" Picture

  # If no local Picture is found, use Gravatar.
  if [ -f "${HOME}/Library/User Pictures/${USER}"* ]; then
    sudo /bin/cp -f "${HOME}/Library/User Pictures/${USER}"* "${USER_PICTURE}"
  else
    sudo /usr/bin/curl -o "${USER_PICTURE}" --silent --location "http://gravatar.com/avatar/$(/sbin/md5 -s "$(/usr/bin/git config --global user.email)" | /usr/bin/awk '{print $NF}').png?s=256"
  fi

  /usr/bin/dscl . append "${HOME}" Picture "${USER_PICTURE}"

  sudo /usr/sbin/chown "${USER}:staff" "${USER_PICTURE}"
  sudo /bin/chmod a=r,u+w "${USER_PICTURE}"

}


install_launchagent_logout_guest_on_idle() {

  local launchd_name='com.apple.LogoutGuestOnIdle'
  local launchd_plist="/Library/LaunchAgents/${launchd_name}.plist"

  sudo /bin/rm -f "${launchd_plist}"

  echo '''
    <plist>
      <dict>
        <key>ProgramArguments</key>
        <array>
          <string>/bin/bash</string>
          <string>-c</string>
          <string>
            GUI_USER="$(stat -f %Su /dev/console)";
            if [ "$GUI_USER" == "Guest" ] &amp;&amp; [ "$(ioreg -c IOHIDSystem | /usr/bin/awk "/HIDIdleTime/ {print \$NF/1000000000; exit}" | /usr/bin/sed -E "s/(\,|\.).*//")" -ge 300 ]; then
              "/System/Library/CoreServices/Menu Extras/User.menu/Contents/Resources/CGSession" -suspend
            fi
          </string>
        </array>
      </dict>
    </plist>
  ''' | sudo tee "${launchd_plist}" &>/dev/null

  sudo /usr/bin/defaults write "${launchd_plist}" Label -string "${launchd_name}"
  sudo /usr/bin/defaults write "${launchd_plist}" RunAtLoad -bool true
  sudo /usr/bin/defaults write "${launchd_plist}" StartInterval -int 10

  sudo /usr/sbin/chown root:admin "${launchd_plist}"
  sudo /bin/chmod 755 "${launchd_plist}"

}
