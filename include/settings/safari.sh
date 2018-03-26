#!/bin/sh


# Safari Defaults

defaults_safari() {

  echo -b 'Setting defaults for Safari …'

  # Change Safari's In-Page Search to “contains” instead of “starts with”
  /usr/bin/defaults write com.apple.Safari FindOnPageMatchesWordStartsOnly -bool false

  # Don't open “safe” Downloads
  /usr/bin/defaults write com.apple.Safari AutoOpenSafeDownloads -bool false

  # Enable Developer Menu
  /usr/bin/defaults write com.apple.Safari WebKitDeveloperExtrasEnabledPreferenceKey -bool true

  # Set “DuckDuckGo” as Default Search Provider
  /usr/bin/defaults write -g NSPreferredWebServices -dict-add NSWebServicesProviderWebSearch '''
    <dict>
      <key>NSDefaultDisplayName</key>
      <string>DuckDuckGo</string>
      <key>NSProviderIdentifier</key>
      <string>com.duckduckgo</string>
    </dict>
  '''

  # Enable Search Suggestions
  /usr/bin/defaults write com.apple.Safari SuppressSearchSuggestions -bool false

  /usr/bin/killall cfprefsd &>/dev/null

}
