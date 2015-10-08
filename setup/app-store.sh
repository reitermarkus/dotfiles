#!/bin/sh


appstoreInstall() {

  appJson=$(echo $(curl -fsSL "https://itunes.apple.com/lookup?id=$1"))

  appName=$(echo $appJson | python -mjson.tool | sed -n -e '/"trackName":/ s/^.*"\(.*\)".*/\1/p')
  appUrl="macappstore://itunes.apple.com/app/id$(echo $appJson | python -mjson.tool | sed -n -e '/"trackId":/ s/^.*": \(.*\),.*/\1/p')"
  bundleId=$(echo $appJson | python -mjson.tool | sed -n -e '/"bundleId":/ s/^.*"\(.*\)".*/\1/p')
  appPath() { mdfind kMDItemCFBundleIdentifier==$bundleId; }
  appDownload="$appName".appdownload

  if [ "$(appPath)" == '' ]; then

    open -gj $appUrl && cecho "Opening $appName in App Store …" $blue

    appInstallSuccessful=$(osascript <<EOF
tell application "System Events"

  tell application process "App Store"

    repeat 300 times
      if button 1 of group 1 of group 1 of UI element 1 of scroll area 1 of group 1 of group 1 of window 1 exists then
        if description of button 1 of group 1 of group 1 of UI element 1 of scroll area 1 of group 1 of group 1 of window 1 contains "Install" then
          delay 5
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
EOF)

    if [ "$appInstallSuccessful" == "false" ]; then
      echo_error "Error installing $appName."
    else
      timeout=60
      until [ -d "/Applications/$appDownload" ] || [ "$(appPath)" != '' ] || [ $timeout -eq 0 ]; do
        let timeout=timeout-1
        sleep 0.5
      done
      if [ $timeout -gt 0 ]; then
        cecho "Downloading $appName …" $blue
      else
        echo_error "Downloading $appName timed out."
      fi

    fi

  else
    echo_exists "$appName"
  fi

}


# Install Apps

# Byword
  appstoreInstall 420212497

# Deliveries
  appstoreInstall 924726344

# Fusio
  appstoreInstall 480664966

# Gemini
  appstoreInstall 463541543

# Keynote
  appstoreInstall 409183694

# LiveReload
  appstoreInstall 482898991

# Numbers
  appstoreInstall 409203825

# Pages
  appstoreInstall 409201541

# RapidClick
  appstoreInstall 419891002

# Reeder
  # appstoreInstall 880001334

# Xcode
  appstoreInstall 497799835
