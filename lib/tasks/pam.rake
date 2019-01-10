# frozen_string_literal: true

task :pam => [:'brew:casks_and_formulae'] do
  prefix = capture('brew', '--prefix', 'pam-touch-id').strip
  install_script = "#{prefix}/bin/pam_touchid_install"
  next unless File.executable?(install_script)

  capture sudo, install_script
  capture sudo, '/usr/bin/sed', '-i', '', '-E', 's/"reason=[^"]*"/"reason=einen Befehl als Administrator ausführen"/', '/etc/pam.d/sudo'
end
