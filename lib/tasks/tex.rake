# frozen_string_literal: true

task :tex => [:'brew:casks_and_formulae'] do
  next unless (tlmgr = which 'tlmgr')

  launchd_name = 'tlmgr'
  launchd_plist = "/Library/LaunchDaemons/#{launchd_name}.plist"

  plist = {
    'Label' => launchd_name,
    'RunAtLoad' => true,
    'StartInterval' => 3600,
    'KeepAlive' => {
      'Crashed' => true,
      'SuccessfulExit' => false,
    },
    'ThrottleInterval' => 60,
    'ProgramArguments' => [tlmgr, 'update', '--all', '--self', '--reinstall-forcibly-removed'],
    'StandardOutPath' => "/var/log/#{launchd_name}.log",
    'StandardErrorPath' => "/var/log/#{launchd_name}.log",
  }

  capture sudo, '/usr/bin/tee', launchd_plist, input: plist.to_plist

  command sudo, '/usr/sbin/chown', 'root:wheel', launchd_plist
  command sudo, '/bin/chmod', '0644', launchd_plist

  capture sudo, '/bin/launchctl', 'load', '-w', launchd_plist
end
