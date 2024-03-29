# frozen_string_literal: true

require 'defaults'
require 'killall'

task :safari do
  puts ANSI.blue { 'Configuring Safari …' }

  defaults app: 'Safari' do
    # Change Safari's In-Page Search to “contains” instead of “starts with”.
    write 'FindOnPageMatchesWordStartsOnly', false

    # Enable Search Suggestions.
    write 'SuppressSearchSuggestions', false

    # Don't open “safe” Downloads.
    write 'AutoOpenSafeDownloads', false

    # Enable Developer Menu.
    write 'IncludeDevelopMenu', true
    write 'WebKitDeveloperExtrasEnabledPreferenceKey', true
    write 'com.apple.Safari.ContentPageGroupIdentifier.WebKit2DeveloperExtrasEnabled', true

    write 'SearchProviderShortName', 'DuckDuckGo'
    write 'SearchProviderIdentifier', 'com.duckduckgo'
  end

  # Set “DuckDuckGo” as Default Search Provider.
  defaults 'NSGlobalDomain' do
    write 'NSPreferredWebServices', {
      'NSWebServicesProviderWebSearch' => {
        'NSDefaultDisplayName' => 'DuckDuckGo',
        'NSProviderIdentifier' => 'com.duckduckgo',
      },
    }
  end

  killall 'cfprefsd'
end
