# frozen_string_literal: true

task :steam do
  login_item = begin
    capture(
      '/usr/bin/osascript', '-e',
      'tell application "System Events" to get the name of every login item contains "Steam"',
    ).strip == 'true'
  rescue NonZeroExit
    false
  end

  command '/usr/bin/osascript', '-e', 'tell application "System Events" to delete login item "Steam"' if login_item

  # Disable Steam news pop-up.
  path = Pathname('~/Library/Application Support/Steam/userdata/46026291/config/localconfig.vdf').expand_path
  path.write path.read.gsub(/("NotifyAvailableGames"\s+")1(")/, '\10\2') if path.exist?
end
