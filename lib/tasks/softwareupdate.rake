# frozen_string_literal: true

require 'macos'

namespace :softwareupdate do
  task :rosetta do
    next unless arm?

    capture sudo, '/usr/sbin/softwareupdate', '--install-rosetta', '--agree-to-license'
  end
end

task :softwareupdate do
  puts ANSI.blue { 'Enabling automatic software updates …' }

  defaults '/Library/Preferences/com.apple.commerce' do
    write 'AutoUpdate', true
    write 'AutoUpdateRestartRequired', true
  end

  defaults '/Library/Preferences/com.apple.SoftwareUpdate' do
    write 'AutomaticCheckEnabled', true
    write 'AutomaticDownload', true
    write 'ConfigDataInstall', true
    write 'CriticalUpdateInstall', true
    write 'ScheduleFrequency', 1 # daily
  end

  capture sudo, '/usr/sbin/softwareupdate', '--schedule', 'on'
end
