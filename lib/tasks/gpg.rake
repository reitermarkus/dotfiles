# frozen_string_literal: true

require 'add_line_to_file'
require 'which'

task :gpg => [:'brew:casks_and_formulae'] do
  gnupg_home = '~/.config/gnupg'
  gnupg_home_path = Pathname(gnupg_home).expand_path

  ENV['GNUPGHOME'] = gnupg_home_path.to_path
  add_line_to_file fish_environment, "set -x GNUPGHOME #{gnupg_home}"
  add_line_to_file bash_environment, "export GNUPGHOME=#{gnupg_home}"

  gnupg_home_path.mkpath
  chmod_R 'go-rwx', gnupg_home_path.realpath

  if macos?
    raise if (pinentry = which('pinentry-mac')).nil?

    gpg_agent_conf = gnupg_home_path.join('gpg-agent.conf')
    gpg_agent_conf.write <<~CFG
      pinentry-program \"#{pinentry}\"
    CFG

    command 'gpgconf', '--kill', 'gpg-agent'

    launchd_name = 'org.gnupg.environment'
    launchd_plist = "/Library/LaunchAgents/#{launchd_name}.plist"

    plist = {
      'Label' => launchd_name,
      'RunAtLoad' => true,
      'ProgramArguments' => [
        '/bin/bash', '-c', "launchctl setenv GNUPGHOME #{gnupg_home}",
      ],
    }

    capture sudo, '/usr/bin/tee', launchd_plist, input: plist.to_plist
    command sudo, '/usr/sbin/chown', 'root:wheel', launchd_plist
    command sudo, '/bin/chmod', '0644', launchd_plist

    capture '/bin/launchctl', 'load', '-w', launchd_plist
  end

  if linux?
    command sudo, '/usr/bin/mkdir', '-p', '/etc/environment.d'
    command sudo, '/usr/bin/tee', '/etc/environment.d/90gpg.conf', input: "GNUPGHOME=#{gnupg_home}"
  end
end
