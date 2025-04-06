# frozen_string_literal: true

require 'environment'

task :mise => [:'brew:casks_and_formulae'] do
  puts ANSI.blue { 'Configuring mise …' }

  add_line_to_file bash_environment, 'eval "$(mise activate bash)"'
end
