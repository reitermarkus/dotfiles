#!/bin/sh


appstore_install() {

  app_json=$(echo $(curl -fsSL "https://itunes.apple.com/lookup?id=$1"))

  app_name=$(echo $app_json | python -mjson.tool | sed -n -e '/"trackName":/ s/^.*"\(.*\)".*/\1/p')
  app_url="macappstore://itunes.apple.com/app/id$(echo $app_json | python -mjson.tool | sed -n -e '/"trackId":/ s/^.*": \(.*\),.*/\1/p')"
  bundle_id=$(echo $app_json | python -mjson.tool | sed -n -e '/"bundleId":/ s/^.*"\(.*\)".*/\1/p')
  app_path() { mdfind kMDItemCFBundleIdentifier==$bundle_id; }
  app_download="${app_name}.app_download"

  if [ "$(app_path)" == '' ]; then

    open -gj $app_url && cecho "Opening $app_name in App Store …" $blue

    app_install_success=$(osascript <<EOF
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

    if [ "$app_install_success" == "false" ]; then
      cecho "Error installing ${app_name}." $red
    else
      timeout=30
      until [ -d "/Applications/$app_download" ] || [ "$(app_path)" != '' ] || [ $timeout -eq 0 ]; do
        let timeout=timeout-0.5
        sleep 0.5
      done
      if [ $timeout -gt 0 ]; then
        cecho "Downloading ${app_name} …" $blue
      else
        cecho "Downloading ${app_name} timed out." $red
      fi

    fi

  else
    cecho "${app_name} is already installed." $green
  fi

}


# Install Apps

# Auction Sniper for eBay
  appstore_install 608292802

# Byword
  appstore_install 420212497

# Deliveries
  appstore_install 924726344

# Fusio
  appstore_install 480664966

# Gemini
  appstore_install 463541543

# iStudiez Pro
  appstore_install 402989379

# Keynote
  appstore_install 409183694

# LiveReload
  appstore_install 482898991

# Numbers
  appstore_install 409203825

# Pages
  appstore_install 409201541

# RapidClick
  appstore_install 419891002

# Reeder
  # appstore_install 880001334

# RegexToolbox
  appstore_install 954196690

# Repeater
  # appstore_install 443370764

# Xcode
  appstore_install 497799835

  if ! xcodebuild -version &>/dev/null; then
    cecho 'Waiting for Xcode to finish installing …' $blue

    until xcodebuild -version &>/dev/null; do
      sleep 5
    done && sudo xcodebuild -license accept &
  fi

# yRegex
  appstore_install 892115848
