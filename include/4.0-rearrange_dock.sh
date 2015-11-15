#!/bin/sh


# Rearrange Dock Icons

dutil() {

  last=false
  local remove_only=false

  local OPTIND
  while getopts ":p:n:a:lr" o; do
    case "${o}" in
      p) path="${OPTARG}";;
      n) name="${OPTARG}";;
      a) after="${OPTARG}";;
      l) last=true;;
      r) remove_only=true;;
    esac
  done
  shift $((OPTIND-1))

  dockutil --remove "${name}" --no-restart  &>/dev/null

  if [ "${remove_only}" == false ] && [ -d "${path}" ]; then

    local restart=''
    [[ ${last} == false ]] && restart='--no-restart'

    local position=''
    [[ -z ${after} ]] && position='--position beginning'

    dockutil --add "${path}" --label "${name}" --after "${after}" ${position} ${restart}

    after="${name}"

  fi

}


rearrange_dock() {

  if hash dockutil; then

    echo -b 'Rearranging Dock …'

    dutil -rn System\ Preferences
    dutil -rn Systemeinstellungen &>/dev/null
    dutil -rn App\ Store
    dutil -rn Maps
    dutil -rn Karten &>/dev/null
    dutil -rn Contacts
    dutil -rn Kontakte &>/dev/null
    dutil -rn Calendar
    dutil -rn Kalender &>/dev/null
    dutil -rn Reminders
    dutil -rn Erinnerungen &>/dev/null
    dutil -rn FaceTime
    dutil -rn Feedback\ Assistant
    dutil -rn Feedback-Assistent &>/dev/null

    dutil -n Launchpad                     -p /Applications/Launchpad.app
    dutil -n Safari                        -p /Applications/Safari.app
    dutil -n Mail                          -p /Applications/Mail.app
    dutil -n Reeder                        -p /Applications/Reeder.app
    dutil -n Notizen                       -p /Applications/Notes.app
    dutil -n Nachrichten                   -p /Applications/Messages.app
    dutil -n iTunes                        -p /Applications/iTunes.app
    dutil -n Fotos                         -p /Applications/Photos.app
    dutil -n iBooks                        -p /Applications/iBooks.app
    dutil -n Pages                         -p /Applications/Pages.app
    dutil -n Numbers                       -p /Applications/Numbers.app
    dutil -n Xcode                         -p /Applications/Xcode.app
    dutil -n TextMate                      -p /Applications/TextMate.app
    dutil -n Tower                         -p /Applications/Tower.app
    dutil -n Adobe\ Photoshop\ CC\ 2015    -p /Applications/Adobe\ Photoshop\ CC\ 2015/Adobe\ Photoshop\ CC\ 2015.app
    dutil -ln Adobe\ Illustrator\ CC\ 2015 -p /Applications/Adobe\ Illustrator\ CC\ 2015/Adobe\ Illustrator.app

  fi

}
