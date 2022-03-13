# frozen_string_literal: true

task :pam do
  next unless File.exist?('/usr/lib/pam/pam_tid.so.2')
  next if File.read('/etc/pam.d/sudo').include?('pam_tid.so')

  capture sudo, '/usr/bin/sed', '-i', '', "2i\\\nauth       sufficient     pam_tid.so\\\n", '/etc/pam.d/sudo'
end
