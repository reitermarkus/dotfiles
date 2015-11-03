#!/bin/sh


# Install Apps from the Mac App Store

appstore_install() {

  local app_id="${1}"

  killall 'App Store' &>/dev/null

  app_json=$(echo $(curl -fsSL "https://itunes.apple.com/lookup?id=${app_id}"))

  app_name=$(echo $app_json | sed -e 's/.*trackName":"//g' | sed -e 's/",.*//g')
  app_url="macappstore://itunes.apple.com/app/id$(echo $app_json | sed -e 's/.*"trackId"://g' | sed -e 's/,.*//g')"
  bundle_id=$(echo $app_json | sed -e 's/.*"bundleId":"//g' | sed -e 's/",.*//g')
  app_path() { mdfind kMDItemCFBundleIdentifier==${bundle_id}; }
  app_download="/Applications/${app_name}.appdownload"

  if [ "$(app_path)" == '' ]; then

    open -gj "${app_url}" && echo -b "Opening ${app_name} in App Store …"

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

    return false

  end tell
end tell
EOF)

    if [ "$app_install_success" == "false" ]; then
      echo -r "Error installing ${app_name}."
    else

      local timeout=30
      until [ -d "${app_download}" ] || [ "$(app_path)" != '' ] || [ $timeout -eq 0 ]; do
        ((timeout--))
        sleep 1
      done

      if [ $timeout -gt 0 ]; then
        echo -b "Downloading ${app_name} …"
      else
        echo -r "Downloading ${app_name} timed out."
      fi

    fi

  else
    echo -g "${app_name} is already installed."
  fi

}


# Install App Store Applications

install_appstore_apps() {

  appstore_install 608292802 # Auction Sniper for eBay
  appstore_install 420212497 # Byword
  appstore_install 924726344 # Deliveries
  appstore_install 480664966 # Fusio
  appstore_install 463541543 # Gemini
  appstore_install 402989379 # iStudiez Pro
  appstore_install 409183694 # Keynote
  appstore_install 482898991 # LiveReload
  appstore_install 409203825 # Numbers
  appstore_install 409201541 # Pages
  appstore_install 419891002 # RapidClick
# appstore_install 880001334 # Reeder
  appstore_install 954196690 # RegexToolbox
  appstore_install 443370764 # Repeater
  appstore_install 892115848 # yRegex

}


# Install Xcode

install_xcode() {

  appstore_install 497799835 # Xcode
  until sudo xcodebuild -license accept &>/dev/null; do sleep 5; done &
  wait_for_xcode_pid=${!}

}

check_if_xcode_is_installed() {

  if ps -p ${wait_for_xcode_pid} &>/dev/null; then
    echo -b "Still waiting for Xcode to install …"
    wait ${wait_for_xcode_pid} && echo -g 'Xcode installed and license accepted.'
  fi

}
