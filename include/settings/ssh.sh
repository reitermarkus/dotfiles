defaults_ssh() {

  # Automatically add SSH Keys to Keychain on startup.
  install_launchagent_ssh_add

}

install_launchagent_ssh_add() {

  local launchd_name='com.apple.ssh-add'
  local launchd_plist="/Library/LaunchAgents/${launchd_name}.plist"

  sudo -E -- /bin/rm -f "${launchd_plist}"

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
  ''' | sudo -E -- /usr/bin/tee "${launchd_plist}" >/dev/null

  sudo -E -- /usr/bin/defaults write "${launchd_plist}" Label -string "${launchd_name}"
  sudo -E -- /usr/bin/defaults write "${launchd_plist}" RunAtLoad -bool true
  sudo -E -- /usr/bin/defaults write "${launchd_plist}" StartInterval -int 10

  sudo -E -- /usr/sbin/chown root:admin "${launchd_plist}"
  sudo -E -- /bin/chmod 755 "${launchd_plist}"

}
