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
  chmod_R 'go-rw', gnupg_home_path

  raise if (pinentry = which('pinentry-mac')).nil?

  gpg_agent_conf = gnupg_home_path.join('gpg-agent.conf')
  add_line_to_file gpg_agent_conf, "pinentry-program \"#{pinentry}\""

  command 'gpgconf', '--kill', 'gpg-agent'
end
