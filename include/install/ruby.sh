gem() {

  GEM_INSTALLED_GEMS="${GEM_INSTALLED_GEMS:-$(command gem list --no-versions 2>/dev/null)}"

  case "${1}" in
  install)
    local gem="${2}"
    if array_contains_exactly "${GEM_INSTALLED_GEMS}" "${gem}"; then
      echo -g "${gem} is already installed."
    else
      echo -b "Installing ${gem} …"
      command gem "${@}"
    fi
    ;;
  *)
    command gem "${@}"
    ;;
  esac

}

install_ruby_gems() {

  rbenv rehash

  # Install Ruby Gems
  gem install bundler

}

