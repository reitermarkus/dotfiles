# frozen_string_literal: true

require 'pathname'

task :fonts => [:'brew:casks_and_formulae'] do
  if macos?
    icloud_fonts_dir = Pathname('~/Library/Mobile Documents/com~apple~CloudDocs/Library/Fonts').expand_path
    icloud_fonts_dir.mkpath

    local_fonts_dir = Pathname('~/Library/Fonts').expand_path
    local_fonts_dir.mkpath

    raise unless (unison = which 'unison')

    launchd_name = 'fonts'
    launchd_plist = Pathname("~/Library/LaunchAgents/#{launchd_name}.plist").expand_path

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

    launchd_plist.dirname.mkpath
    launchd_plist.write plist.to_plist

    capture '/bin/launchctl', 'load', launchd_plist.to_path
  end

  if linux?
    command 'sudo', 'ln', '-sfn', '/home/linuxbrew/.linuxbrew/share/fonts', '-t', '/usr/local/share'
    command 'sudo', 'fc-cache', '-fv'
  end
end
