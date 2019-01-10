# frozen_string_literal: true

task :itunes do
  defaults 'com.apple.iTunes' do
    preferences = read 'pref:130:Preferences'

    next if preferences.nil?

    preferences.set_encoding(Encoding::BINARY)
    preferences = preferences.string

    # Don't automatically sync iOS devices.
    preferences[0x388f] = "\x01"

    # Automatically download album covers.
    preferences[0x56f3] = "\x01"

    # Show status bar.
    preferences[0xf796] = "\x01"

    write 'pref:130:Preferences', StringIO.new(preferences)
  end
end
