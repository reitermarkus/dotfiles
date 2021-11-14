# frozen_string_literal: true

require 'add_line_to_file'
require 'which'

task :gpg => [:'brew:casks_and_formulae'] do
  gnupg_dir = Pathname('~/.gnupg').expand_path

  gnupg_dir.mkpath
  chmod_R 'go-rw', gnupg_dir

  raise if (pinentry = which('pinentry-mac')).nil?

  gpg_agent_conf = gnupg_dir.join('gpg-agent.conf')
  add_line_to_file gpg_agent_conf, "pinentry-program \"#{pinentry}\""

  command 'gpgconf', '--kill', 'gpg-agent'
end
