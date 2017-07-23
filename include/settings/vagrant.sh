defaults_vagrant() {

  if which vagrant &>/dev/null; then
    if ! vagrant plugin list | /usr/bin/grep -q vagrant-parallels; then
      vagrant plugin install vagrant-parallels
    fi

    if ! vagrant plugin list | /usr/bin/grep -q vagrant-hostsupdater; then
      vagrant plugin install vagrant-hostsupdater
    fi
  fi

}
