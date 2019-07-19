# frozen_string_literal: true

require 'pathname'

task :fonts do
  icloud_fonts_dir = Pathname('~/Library/Mobile Documents/com~apple~CloudDocs/Library/Fonts').expand_path
  icloud_fonts_dir.mkpath

  local_fonts_dir = Pathname('~/Library/Fonts').expand_path
  local_fonts_dir.mkpath

  raise unless (unison = which 'unison')

  launchd_name = 'fonts'
  launchd_plist = File.expand_path("~/Library/LaunchAgents/#{launchd_name}.plist")

  plist = {
    'Label' => launchd_name,
    'RunAtLoad' => true,
    'StartInterval' => 3600,
    'KeepAlive' => {
      'Crashed' => true,
      'SuccessfulExit' => false,
    },
    'ThrottleInterval' => 60,
    'ProgramArguments' => [unison.to_s, '-log=false', '-auto', '-batch', icloud_fonts_dir.to_s, local_fonts_dir.to_s],
    'StandardOutPath' => "/usr/local/var/log/#{launchd_name}.log",
    'StandardErrorPath' => "/usr/local/var/log/#{launchd_name}.log",
    'WatchPaths' => [icloud_fonts_dir.to_s, local_fonts_dir.to_s],
  }

  File.write launchd_plist, plist.to_plist

  capture '/bin/launchctl', 'load', launchd_plist
end
