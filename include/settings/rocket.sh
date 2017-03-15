defaults_rocket() {

  # Rocket
  /usr/bin/defaults write net.matthewpalmer.Rocket launch-at-login     -bool true
  /usr/bin/defaults write net.matthewpalmer.Rocket preferred-skin-tone -int 2

  add_login_item net.matthewpalmer.Rocket hidden

}
