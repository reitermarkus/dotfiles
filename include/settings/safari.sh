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
  /usr/bin/defaults write com.apple.Safari SearchProviderIdentifier -string 'com.duckduckgo'

  # Enable Search Suggestions
  /usr/bin/defaults write com.apple.Safari SuppressSearchSuggestions -bool false

}
