defaults_tower() {

  # Tower
  /usr/bin/defaults write com.fournova.Tower2 GTUserDefaultsGitBinary -string "$(which git)"

}
