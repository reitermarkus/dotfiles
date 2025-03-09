# frozen_string_literal: true

require 'add_line_to_file'

task :direnv => :fish do
  add_line_to_file fish_environment('direnv'), 'direnv hook fish | source'
  add_line_to_file bash_environment, 'eval "$(direnv hook bash)"'
end
