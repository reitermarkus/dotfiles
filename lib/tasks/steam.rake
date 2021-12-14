# frozen_string_literal: true

require 'vdf'
require 'login_item'

task :steam do
  remove_login_item 'com.valvesoftware.steam'

  steam_dir = Pathname('~/Library/Application Support/Steam').expand_path

  localconfig_path = steam_dir.join('userdata/46026291/config/localconfig.vdf')
  localconfig_path.dirname.mkpath
  FileUtils.touch localconfig_path

  vdf = VDF.parse(File.read(localconfig_path))

  vdf['UserLocalConfigStore'] ||= {}
  vdf['UserLocalConfigStore']['News'] ||= {}

  # Disable Steam news pop-up.
  vdf['UserLocalConfigStore']['News']['NotifyAvailableGames'] = 0

  File.write localconfig_path, VDF.generate(vdf)

  steamapps_path = steam_dir.join('steamapps')
  steamapps_path.mkpath
  capture 'tmutil', 'addexclusion', steamapps_path.to_path
end
