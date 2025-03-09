# frozen_string_literal: true

require 'environment'
require 'add_line_to_file'

task :node => [:asdf] do
  puts ANSI.blue { 'Configuring Node …' }

  ENV['ASDF_NODEJS_LEGACY_FILE_DYNAMIC_STRATEGY'] = 'latest_available'
  add_line_to_file fish_environment('asdf'), 'set -x ASDF_NODEJS_LEGACY_FILE_DYNAMIC_STRATEGY latest_available'
  add_line_to_file bash_environment, 'export ASDF_NODEJS_LEGACY_FILE_DYNAMIC_STRATEGY=latest_available'

  command 'asdf', 'plugin', 'add', 'nodejs'
  command 'asdf', 'cmd', 'nodejs', 'update-nodebuild'
  command 'asdf', 'install', 'nodejs', 'lts'
  command 'asdf', 'set', '--home', 'nodejs', 'lts'
end
