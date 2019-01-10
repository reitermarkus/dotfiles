# frozen_string_literal: true

task :steam do
  command '/usr/bin/osascript', '-e', 'tell application "System Events" to delete login item "Steam"' if capture('/usr/bin/osascript', '-e', 'tell application "System Events" to get the name of every login item contains "Steam"').strip == 'true'
end
