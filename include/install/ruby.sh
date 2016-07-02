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

  echo -b 'Installing Ruby Gem Update Daemon …'
  cat <<EOF > ~/Library/LaunchAgents/org.rubygems.updater.plist
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
  <key>StartInterval</key>
  <integer>21600</integer>
  <key>Label</key>
  <string>org.rubygems.updater</string>
  <key>ProgramArguments</key>
  <array>
    <string>$(which gem)</string>
    <string>update</string>
    <string>-V</string>
  </array>
  <key>RunAtLoad</key>
  <true/>
</dict>
</plist>
EOF

  launchctl load ~/Library/LaunchAgents/org.rubygems.updater.plist &>/dev/null

  # Install Ruby Gems
  if local ruby_gems=$(gem list | /usr/bin/awk '{print $1}'); then

    echo -b 'Updating Ruby Gems …'
    gem update --system

    # Install Ruby Gems
    gem_install -g bundler -n Bundler

  fi
}

