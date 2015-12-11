defaults_dock() {

  # Dock
  echo -b 'Setting defaults for Dock …'

  # Minimize Windows behind Dock Icon
  defaults write com.apple.dock minimize-to-application -bool  true

  # Automatically hide Dock
  defaults write com.apple.dock autohide -bool true

  # Translucent Icons of hidden Applications
  defaults write com.apple.dock showhidden -bool true

  # Rearrange Dock Icons
  set_dock_icons


  # Mission Control

  # Disable Dashboard
  defaults write com.apple.dashboard enabled-state -int 1

  # Increase Mission Control Animation Speed
  defaults write com.apple.dock expose-animation-duration -float 0.125
  defaults write com.apple.dock expose-group-apps         -bool  true


  # Desktop

  desktop_pictures_dir="${HOME}/Library/Desktop Pictures"
  defaults write com.apple.systempreferences DSKDesktopPrefPane """
    {
      UserFolderPaths = (
        '${desktop_pictures_dir}',
      );
    }
  """
  sqlite3 "${HOME}/Library/Application Support/Dock/desktoppicture.db" "update data set value = '${desktop_pictures_dir}/current'"


  # Screensaver

  # Password after Screensaver
  defaults write com.apple.screensaver askForPassword -bool true

  # Set Screensaver and Password Delay
  if is_laptop; then
    defaults -currentHost write com.apple.screensaver idleTime -int 120
    defaults write com.apple.screensaver askForPasswordDelay   -int 60
  else
    defaults -currentHost write com.apple.screensaver idleTime -int 300
    defaults write com.apple.screensaver askForPasswordDelay   -int 300
  fi

  # Don't show Clock on Screensaver
  defaults -currentHost write com.apple.screensaver showClock -bool false


  killall cfprefsd &>/dev/null
  killall Dock &>/dev/null

}


set_dock_icons() {

  if type dockutil &>/dev/null; then

    add_to_dock() {

      local name
      local path
      local position

      local OPTIND
      while getopts ":p:n:" o; do
        case "${o}" in
          p) path="${OPTARG}";;
          n) name="${OPTARG}";;
        esac
      done
      shift $((OPTIND-1))

      if [ "${name}" == "" ]; then
        name="$(basename "${path%.*}")"
      fi

      if [ -z "${after}" ]; then
        position='--position beginning'
      fi

      dockutil --no-restart --remove "${name}" &>/dev/null

      if [ -d "${path}" ]; then
        dockutil --no-restart \
          --add "${path}" \
          --label "${name}" --replacing "${name}" \
          --after "${after}" ${position}

        after="${name}"
      fi

    }

    dockutil --no-restart \
      --remove 'System Preferences' --remove 'Systemeinstellungen' \
      --remove 'App Store' \
      --remove 'Maps' --remove 'Karten' \
      --remove 'Notes' \
      --remove 'Photos' \
      --remove 'Messages' \
      --remove 'Contacts' --remove 'Kontakte' \
      --remove 'Calendar' --remove 'Kalender' \
      --remove 'Reminders' --remove 'Erinnerungen' \
      --remove 'FaceTime' \
      --remove 'Feedback Assistant' --remove 'Feedback-Assistent' \
    &>/dev/null

    unset after

    add_to_dock -p '/Applications/Launchpad.app'
    add_to_dock -p '/Applications/Safari.app'
    add_to_dock -p '/Applications/Mail.app'
    add_to_dock -p '/Applications/Reeder.app'
    add_to_dock -p '/Applications/Notes.app' -n 'Notizen'
    add_to_dock -p '/Applications/Messages.app' -n 'Nachrichten'
    add_to_dock -p '/Applications/iTunes.app'
    add_to_dock -p '/Applications/Photos.app' -n 'Fotos'
    add_to_dock -p '/Applications/iBooks.app'
    add_to_dock -p '/Applications/Pages.app'
    add_to_dock -p '/Applications/Numbers.app'
    add_to_dock -p '/Applications/Xcode.app'
    add_to_dock -p '/Applications/Terminal.app'
    add_to_dock -p '/Applications/TextMate.app'
    add_to_dock -p '/Applications/Tower.app'
    add_to_dock -p '/Applications/Adobe Photoshop CC 2015/Adobe Photoshop CC 2015.app'
    add_to_dock -p '/Applications/Adobe Illustrator CC 2015/Adobe Illustrator.app' -n 'Adobe Illustrator CC 2015'

  fi

}
