defaults_ssh() {

  # Automatically add SSH Keys to Keychain on startup.
  install_launchagent_ssh_add

}

install_launchagent_ssh_add() {

  local launchd_name='com.apple.ssh-add'
  local launchd_plist="/Library/LaunchAgents/${launchd_name}.plist"

  /usr/bin/sudo -E -- /bin/rm -f "${launchd_plist}"

  echo '''
    <plist>
      <dict>
        <key>Label</key>
        <string>ssh-add-a</string>
        <key>ProgramArguments</key>
        <array>
          <string>/usr/bin/ssh-add</string>
          <string>-A</string>
        </array>
        <key>RunAtLoad</key>
        <true/>
      </dict>
    </plist>
  ''' | /usr/bin/sudo -E -- /usr/bin/tee "${launchd_plist}" >/dev/null

  /usr/bin/sudo -E -- /usr/bin/defaults write "${launchd_plist}" Label -string "${launchd_name}"
  /usr/bin/sudo -E -- /usr/bin/defaults write "${launchd_plist}" RunAtLoad -bool true
  /usr/bin/sudo -E -- /usr/bin/defaults write "${launchd_plist}" StartInterval -int 10

  /usr/bin/sudo -E -- /usr/sbin/chown root:admin "${launchd_plist}"
  /usr/bin/sudo -E -- /bin/chmod 755 "${launchd_plist}"

}
