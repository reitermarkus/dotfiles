defaults_loginwindow() {

  # Login Window
  echo -b 'Setting defaults for Login Window …'

  # Disable Guest Account
  /usr/bin/sudo -E -- /usr/bin/defaults write /Library/Preferences/com.apple.loginwindow GuestEnabled -bool false
  /usr/bin/sudo -E -- /usr/bin/defaults write /Library/Preferences/com.apple.AppleFileServer guestAccess -bool false
  /usr/bin/sudo -E -- /usr/bin/defaults write /Library/Preferences/SystemConfiguration/com.apple.smb.server AllowGuestAccess -bool false
  /usr/bin/sudo -E -- /bin/rm -rf /Users/Guest

  # Automatically log out the Guest when idle.
  install_launchagent_logout_guest_on_idle

  # Show the Sleep, Restart and Shut Down Buttons
  /usr/bin/sudo -E -- /usr/bin/defaults write /Library/Preferences/com.apple.loginwindow 'PowerOffDisabled' -bool false

  # Show Input Menu in Login Window
  /usr/bin/sudo -E -- /usr/bin/defaults write /Library/Preferences/com.apple.loginwindow 'showInputMenu' -bool true

  # Hide Password Hints
  /usr/bin/sudo -E -- /usr/bin/defaults write /Library/Preferences/com.apple.loginwindow 'RetriesUntilHint' -int 0

  # Show Login Text
  if is_laptop; then
    /usr/bin/sudo -E -- /usr/bin/defaults write /Library/Preferences/com.apple.loginwindow.plist LoginwindowText \
      "If found, please contact the owner:\nme@reitermark.us\n@reitermarkus"
  else
    /usr/bin/sudo -E -- /usr/bin/defaults write /Library/Preferences/com.apple.loginwindow.plist LoginwindowText ""
  fi

  # Save open Windows on Logout.
  /usr/bin/defaults write com.apple.loginwindow TALLogoutSavesState -bool true

  # Apply Login Text on FileVault Pre-Boot Screen
  /usr/bin/sudo -E -- /bin/rm -f /System/Library/Caches/com.apple.corestorage/EFILoginLocalizations/preferences.efires

  # Set Account Picture
  USER_PICTURE="/Library/User Pictures/${USER}"

  /usr/bin/sudo -E -- /bin/rm -f "${USER_PICTURE}"*
  /usr/bin/dscl . delete "${HOME}" JPEGPhoto
  /usr/bin/dscl . delete "${HOME}" Picture

  # If no local Picture is found, use Gravatar.
  if [ -f "${HOME}/Library/User Pictures/${USER}"* ]; then
    /usr/bin/sudo -E -- /bin/cp -f "${HOME}/Library/User Pictures/${USER}"* "${USER_PICTURE}"
  else
    /usr/bin/sudo -E -- /usr/bin/curl -o "${USER_PICTURE}" --silent --location "http://gravatar.com/avatar/$(/sbin/md5 -q -s 'me@reitermark.us').png?s=256"
  fi

  /usr/bin/dscl . append "${HOME}" Picture "${USER_PICTURE}"

  /usr/bin/sudo -E -- /usr/sbin/chown "${USER}:staff" "${USER_PICTURE}"
  /usr/bin/sudo -E -- /bin/chmod a=r,u+w "${USER_PICTURE}"

}


install_launchagent_logout_guest_on_idle() {

  local launchd_name='com.apple.LogoutGuestOnIdle'
  local launchd_plist="/Library/LaunchAgents/${launchd_name}.plist"

  /usr/bin/sudo -E -- /bin/rm -f "${launchd_plist}"

  echo '''
    <plist>
      <dict>
        <key>ProgramArguments</key>
        <array>
          <string>/bin/bash</string>
          <string>-c</string>
          <string>
            GUI_USER="$(stat -f %Su /dev/console)";
            if [ "$GUI_USER" == "Guest" ] &amp;&amp; [ $(/usr/sbin/ioreg -c IOHIDSystem | /usr/bin/awk "/HIDIdleTime/ {print int(\$NF/1000000000); exit}") -ge 300 ]; then
              "/System/Library/CoreServices/Menu Extras/User.menu/Contents/Resources/CGSession" -suspend
            fi
          </string>
        </array>
      </dict>
    </plist>
  ''' | /usr/bin/sudo -E -- /usr/bin/tee "${launchd_plist}" >/dev/null

  /usr/bin/sudo -E -- /usr/bin/defaults write "${launchd_plist}" Label -string "${launchd_name}"
  /usr/bin/sudo -E -- /usr/bin/defaults write "${launchd_plist}" RunAtLoad -bool true
  /usr/bin/sudo -E -- /usr/bin/defaults write "${launchd_plist}" StartInterval -int 10

  /usr/bin/sudo -E -- /usr/sbin/chown root:admin "${launchd_plist}"
  /usr/bin/sudo -E -- /bin/chmod 755 "${launchd_plist}"

}
