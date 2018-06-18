task :steam do
  if capture('/usr/bin/osascript', '-e', 'tell application "System Events" to get the name of every login item contains "Steam"').strip == 'true'
    command '/usr/bin/osascript', '-e', 'tell application "System Events" to delete login item "Steam"'
  end
end
