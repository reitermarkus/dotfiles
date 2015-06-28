#!/bin/sh


appstore_install() {

  appid="$1"
  appname="$2"

  if [ ! -d "/Applications/$appname.app" ]; then

    open -gj -a 'App Store' "macappstore://itunes.apple.com/app/$appid"

    app_install_successful=`osascript <<EOF
    tell application "System Events"

      tell application process "App Store"

        repeat 300 times
          if button 1 of group 1 of group 1 of UI element 1 of scroll area 1 of group 1 of group 1 of window 1 exists then
            if description of button 1 of group 1 of group 1 of UI element 1 of scroll area 1 of group 1 of group 1 of window 1 contains "Install" then
              delay 5
              click button 1 of group 1 of group 1 of UI element 1 of scroll area 1 of group 1 of group 1 of window 1
              delay 1
              click button 1 of group 1 of group 1 of UI element 1 of scroll area 1 of group 1 of group 1 of window 1
              return true
            end if
          else
            delay 0.1
          end if
        end repeat

        tell application "App Store" to quit
        return false

      end tell
    end tell
    EOF`

    if [ "$app_install_successful" == "false" ]; then
      cecho "Error installing $appname." $red
    else
      cecho "Installing $appname …" $blue
      timeout=0
      until [ -d "/Applications/$appname*appdownload" ] || [ -d "/Applications/$appname.app" ] || [ $timeout -eq 60 ]; do
        let timeout=timeout+1
        sleep 0.5
      done
    fi

  else
    cecho "$appname already installed." $green
  fi

}


# Install Apps

appstore_install id420212497 Byword
appstore_install id924726344 Deliveries
appstore_install id480664966 Fusio
appstore_install id482898991 LiveReload
appstore_install id419891002 RapidClick
appstore_install id880001334 Reeder


# iWork

appstore_install id409183694 Keynote
appstore_install id409203825 Numbers
appstore_install id409201541 Pages


# Xcode

appstore_install id497799835 Xcode






#
