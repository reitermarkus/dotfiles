#!/bin/sh


# Safari Defaults

defaults_safari() {

  echo -b 'Setting defaults for Safari …'

  # Change Safari's In-Page Search to “contains” instead of “starts with”
  defaults write com.apple.Safari FindOnPageMatchesWordStartsOnly -bool false

  # Don't open “safe” Downloads
  defaults write com.apple.Safari AutoOpenSafeDownloads -bool false

  # Enable Developer Menu
  defaults write com.apple.Safari WebKitDeveloperExtrasEnabledPreferenceKey -bool true

  # Set “DuckDuckGo” as Default Search Provider
  defaults write com.apple.Safari SearchProviderIdentifier -string 'com.duckduckgo'

  # Enable Search Suggestions
  defaults write com.apple.Safari SuppressSearchSuggestions -bool false

}
