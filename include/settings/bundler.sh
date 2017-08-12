defaults_bundler() {

  bundle config --global bin '.bundle/bin'
  bundle config --global jobs "$(/usr/sbin/sysctl -n hw.ncpu)"

}
