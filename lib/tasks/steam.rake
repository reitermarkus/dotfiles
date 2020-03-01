# frozen_string_literal: true

require 'vdf'

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

  path = Pathname('~/Library/Application Support/Steam/userdata/46026291/config/localconfig.vdf').expand_path
  path.dirname.mkpath
  FileUtils.touch path

  vdf = VDF.parse(File.read(path))

  vdf['UserLocalConfigStore'] ||= {}
  vdf['UserLocalConfigStore']['News'] ||= {}

  # Disable Steam news pop-up.
  vdf['UserLocalConfigStore']['News']['NotifyAvailableGames'] = 0

  File.write path, VDF.generate(vdf)
end
