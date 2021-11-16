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

  localconfig_path = Pathname('~/Library/Application Support/Steam/userdata/46026291/config/localconfig.vdf').expand_path
  localconfig_path.dirname.mkpath
  FileUtils.touch localconfig_path

  vdf = VDF.parse(File.read(localconfig_path))

  vdf['UserLocalConfigStore'] ||= {}
  vdf['UserLocalConfigStore']['News'] ||= {}

  # Disable Steam news pop-up.
  vdf['UserLocalConfigStore']['News']['NotifyAvailableGames'] = 0

  File.write localconfig_path, VDF.generate(vdf)

  steamapps_path = Pathname('~/Library/Application Support/Steam/steamapps').expand_path
  steamapps_path.mkpath
  capture 'tmutil', 'addexclusion', steamapps_path.to_path
end
