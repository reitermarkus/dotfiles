defaults_vagrant() {

  # Parallels Provider
  if which vagrant &>/dev/null && which prlctl &>/dev/null; then
    if ! vagrant plugin list | /usr/bin/grep -q vagrant-parallels; then
      vagrant plugin install vagrant-parallels
    fi
  fi

}
