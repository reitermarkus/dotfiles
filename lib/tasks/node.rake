# frozen_string_literal: true

require 'environment'
require 'add_line_to_file'

task :node => :'node:nvm'

namespace :node do
  task :nvm => [:'brew:casks_and_formulae', :fish] do
    nvm_dir = '~/.config/nvm'

    ENV['NVM_DIR'] = File.expand_path(nvm_dir)

    add_line_to_file fish_environment, 'set -x nvm_prefix (brew --prefix nvm 2>&-)'

    add_line_to_file fish_environment, "set -x NVM_DIR #{nvm_dir}"
    add_line_to_file bash_environment, "export NVM_DIR=#{nvm_dir}"

    command 'fish', '-c', 'nvm install node'
    command 'fish', '-c', 'nvm install --lts'
    command 'fish', '-c', 'nvm cache clear'
  end
end
