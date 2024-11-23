# frozen_string_literal: true

require 'environment'
require 'add_line_to_file'

task :node => :'node:asdf'

namespace :node do
  task :asdf => [:asdf] do
    ENV['ASDF_NODEJS_LEGACY_FILE_DYNAMIC_STRATEGY'] = 'latest_available'
    add_line_to_file fish_environment, "set -x ASDF_NODEJS_LEGACY_FILE_DYNAMIC_STRATEGY latest_available"
    add_line_to_file bash_environment, "export ASDF_NODEJS_LEGACY_FILE_DYNAMIC_STRATEGY=latest_available"

    command 'asdf', 'plugin', 'add', 'nodejs'
    command 'asdf', 'install', 'nodejs', 'lts'
    command 'asdf', 'global', 'nodejs', 'lts'
  end
end
