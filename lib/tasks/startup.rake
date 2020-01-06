# frozen_string_literal: true

task :startup do
  # Startup Disk
  volume_name = capture('/usr/sbin/diskutil', 'info', '/').scan(/Volume Name:\s+(.*)/).first.first

  if volume_name != 'Macintosh'
    puts ANSI.blue { "Renaming startup disk from “#{volume_name}” to “Macintosh” …" }
    capture '/usr/sbin/diskutil', 'rename', '/', 'Macintosh'
  end

  # Enable Verbose Boot
  capture sudo, 'nvram', 'boot-args=-v'

  # Restart on Power Failure or Freeze
  if capture(sudo, 'systemsetup', '-getrestartpowerfailure') !~ /Not supported on this machine./
    capture sudo, 'systemsetup', '-setrestartpowerfailure', 'on'
  end

  capture sudo, 'systemsetup', '-setrestartfreeze', 'on'

  # Enable Remote Apple Events, Remote Login & Remote Management
  capture sudo, 'systemsetup', '-setremoteappleevents', 'on'
  capture sudo, 'systemsetup', '-setremotelogin', 'on'
  capture sudo, '/System/Library/CoreServices/RemoteManagement/ARDAgent.app/Contents/Resources/kickstart', '-activate',
          '-configure', '-access', '-on', '-users', 'admin', '-privs', '-all', '-restart', '-agent', '-menu'
end
