gem_install() {

  local gem
  local name

  local OPTIND
  while getopts ":g:n:" o; do
    case "${o}" in
      g)  gem="${OPTARG}";;
      n) name="${OPTARG}";;
    esac
  done
  shift $((OPTIND-1))

  [ -z "${name}" ] && name=${gem}

  if array_contains_exactly "${ruby_gems}" "${gem}"; then
    echo -g "${name} is already installed."
  else
    echo -b "Installing ${name} …"
    gem install "${gem}"
  fi

}

install_ruby_gems() {

  # Install Ruby Gems
  if local ruby_gems=$(gem list | /usr/bin/awk '{print $1}'); then

    echo -b 'Updating Ruby Gems …'
    gem update --system

    # Install Ruby Gems
    gem_install -g bundler -n Bundler

  fi
}

