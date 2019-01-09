task :pam do
  next unless File.exist?('/usr/lib/pam/pam_tid.so.2')
  capture sudo, '/usr/bin/sed', '-i', '', '-n', '-e', '/pam_tid.so/!p', '-e', "1i\\\nauth       sufficient     pam_tid.so\n", '/etc/pam.d/sudo'
end
