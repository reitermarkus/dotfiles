# frozen_string_literal: true

task :tex => [:'brew:casks_and_formulae'] do
  next unless (tlmgr = which 'tlmgr')

  launchd_name = 'tlmgr'
  launchd_plist = "/Library/LaunchAgents/#{launchd_name}.plist"

  plist = {
    'Label' => launchd_name,
    'RunAtLoad' => true,
    'StartInterval' => 3600,
    'ProgramArguments' => [tlmgr, 'update', '--all', '--self'],
    'StandardOutPath' => "/var/log/#{launchd_name}.log",
    'StandardErrorPath' => "/var/log/#{launchd_name}.log",
  }

  capture sudo, '/usr/bin/tee', launchd_plist, input: plist.to_plist

  command sudo, '/usr/sbin/chown', 'root:wheel', launchd_plist
  command sudo, '/bin/chmod', '600', launchd_plist

  capture sudo, '/bin/launchctl', 'load', launchd_plist
end
